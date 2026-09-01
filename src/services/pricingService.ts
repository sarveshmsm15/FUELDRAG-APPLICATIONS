import prisma from "../config/database.js";
import { FuelType } from "../generated/prisma/client.js";
import redis from "../config/redis.js";

interface PricingInput {
  fuelType: FuelType;
  quantityLiters: number;
  distanceKm: number;
  promoCode?: string;
}

interface PricingResult {
  basePrice: number;
  surgeMultiplier: number;
  deliveryFee: number;
  taxAmount: number;
  discountAmount: number;
  totalAmount: number;
  fuelPricePerLiter: number;
  breakdown: Record<string, number>;
}

const DELIVERY_FEE_BASE = 49;
const TAX_RATE = 0.18; // 18% GST
const SURGE_CAP = 2.0;

/**
 * Calculate full pricing for a fuel order.
 */
export async function calculatePricing(input: PricingInput): Promise<PricingResult> {
  const { fuelType, quantityLiters, distanceKm, promoCode } = input;

  // Get current fuel rate
  const fuelRate = await prisma.fuelRate.findFirst({
    where: { fuelType, isActive: true },
    orderBy: { effectiveFrom: "desc" },
  });

  if (!fuelRate) {
    throw new Error(`No active rate found for ${fuelType}`);
  }

  const fuelPricePerLiter = fuelRate.pricePerLiter;
  const basePrice = fuelPricePerLiter * quantityLiters;

  // Surge multiplier based on demand (simplified — count active orders in last 30 min)
  const recentOrders = await prisma.order.count({
    where: {
      createdAt: { gte: new Date(Date.now() - 30 * 60 * 1000) },
      status: { notIn: ["completed", "cancelled", "failed"] },
    },
  });

  let surgeMultiplier = 1.0;
  if (recentOrders > 20) surgeMultiplier = 1.5;
  if (recentOrders > 50) surgeMultiplier = 2.0;
  surgeMultiplier = Math.min(surgeMultiplier, SURGE_CAP);

  // Delivery fee based on distance
  const deliveryFee = DELIVERY_FEE_BASE + Math.max(0, (distanceKm - 5) * 10);

  // Tax on (base * surge + delivery)
  const subtotalWithSurge = basePrice * surgeMultiplier;
  const taxAmount = (subtotalWithSurge + deliveryFee) * TAX_RATE;

  // Promo code discount
  let discountAmount = 0;
  if (promoCode) {
    const promo = await prisma.promoCode.findFirst({
      where: {
        code: promoCode.toUpperCase(),
        isActive: true,
        validFrom: { lte: new Date() },
        validUntil: { gte: new Date() },
      },
    });

    if (promo) {
      const orderTotal = subtotalWithSurge + deliveryFee + taxAmount;
      if (orderTotal >= promo.minOrderAmount) {
        if (promo.usageLimit && promo.usageCount >= promo.usageLimit) {
          // Promo exhausted
        } else if (promo.discountType === "percentage") {
          discountAmount = (orderTotal * promo.discountValue) / 100;
          if (promo.maxDiscount) {
            discountAmount = Math.min(discountAmount, promo.maxDiscount);
          }
        } else {
          discountAmount = promo.discountValue;
        }
      }
    }
  }

  const totalAmount = subtotalWithSurge + deliveryFee + taxAmount - discountAmount;

  return {
    basePrice: Math.round(basePrice * 100) / 100,
    surgeMultiplier,
    deliveryFee: Math.round(deliveryFee * 100) / 100,
    taxAmount: Math.round(taxAmount * 100) / 100,
    discountAmount: Math.round(discountAmount * 100) / 100,
    totalAmount: Math.round(totalAmount * 100) / 100,
    fuelPricePerLiter,
    breakdown: {
      fuelCost: Math.round(subtotalWithSurge * 100) / 100,
      deliveryFee: Math.round(deliveryFee * 100) / 100,
      tax: Math.round(taxAmount * 100) / 100,
      discount: Math.round(discountAmount * 100) / 100,
    },
  };
}

/**
 * Lock a price snapshot for an order (10-min expiry).
 */
export async function lockPrice(orderId: string, pricing: PricingResult, fuelType: FuelType, quantityLiters: number) {
  const snapshot = await prisma.pricingSnapshot.create({
    data: {
      orderId,
      fuelType,
      basePrice: pricing.basePrice,
      surgeMultiplier: pricing.surgeMultiplier,
      deliveryFee: pricing.deliveryFee,
      taxAmount: pricing.taxAmount,
      discountAmount: pricing.discountAmount,
      totalAmount: pricing.totalAmount,
      quantityLiters,
      priceExpiresAt: new Date(Date.now() + 10 * 60 * 1000),
    },
  });

  await redis.set(`pricelock:${orderId}`, snapshot.id, "EX", 600);
  return snapshot;
}