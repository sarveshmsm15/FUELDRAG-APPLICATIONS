/**
 * Unit tests for pricing calculation logic.
 * Tests the pure math without database dependencies.
 */

interface PricingInput {
  pricePerLiter: number;
  quantityLiters: number;
  distanceKm: number;
  surgeMultiplier: number;
  discountPercent: number;
}

interface PricingResult {
  basePrice: number;
  surgeMultiplier: number;
  deliveryFee: number;
  taxAmount: number;
  discountAmount: number;
  totalAmount: number;
}

function calculatePricing(input: PricingInput): PricingResult {
  const basePrice = input.pricePerLiter * input.quantityLiters * input.surgeMultiplier;

  let deliveryFee = 49; // Base fee
  if (input.distanceKm > 5) deliveryFee += (input.distanceKm - 5) * 10;
  if (input.distanceKm > 15) deliveryFee += (input.distanceKm - 15) * 5;

  const subtotal = basePrice + deliveryFee;
  const taxAmount = Math.round(subtotal * 0.18 * 100) / 100;
  const discountAmount = Math.round(subtotal * (input.discountPercent / 100) * 100) / 100;
  const totalAmount = Math.round((subtotal + taxAmount - discountAmount) * 100) / 100;

  return {
    basePrice: Math.round(basePrice * 100) / 100,
    surgeMultiplier: input.surgeMultiplier,
    deliveryFee,
    taxAmount,
    discountAmount,
    totalAmount,
  };
}

describe("Pricing Engine", () => {
  const petrolPrice = 106.31;

  it("should calculate basic pricing for 10L petrol at 5km", () => {
    const result = calculatePricing({
      pricePerLiter: petrolPrice,
      quantityLiters: 10,
      distanceKm: 5,
      surgeMultiplier: 1,
      discountPercent: 0,
    });

    expect(result.basePrice).toBe(1063.1);
    expect(result.deliveryFee).toBe(49);
    expect(result.taxAmount).toBe(200.18);
    expect(result.discountAmount).toBe(0);
    expect(result.totalAmount).toBe(1312.28);
  });

  it("should apply surge multiplier", () => {
    const result = calculatePricing({
      pricePerLiter: petrolPrice,
      quantityLiters: 10,
      distanceKm: 5,
      surgeMultiplier: 1.5,
      discountPercent: 0,
    });

    expect(result.basePrice).toBe(1594.65);
    expect(result.totalAmount).toBeGreaterThan(1312.28);
  });

  it("should increase delivery fee for distances > 5km", () => {
    const result = calculatePricing({
      pricePerLiter: petrolPrice,
      quantityLiters: 10,
      distanceKm: 10,
      surgeMultiplier: 1,
      discountPercent: 0,
    });

    expect(result.deliveryFee).toBe(99); // 49 + (10-5)*10
  });

  it("should apply discount percentage", () => {
    const result = calculatePricing({
      pricePerLiter: petrolPrice,
      quantityLiters: 10,
      distanceKm: 5,
      surgeMultiplier: 1,
      discountPercent: 10,
    });

    expect(result.discountAmount).toBeGreaterThan(0);
    expect(result.totalAmount).toBeLessThan(1312.28);
  });

  it("should handle diesel pricing", () => {
    const result = calculatePricing({
      pricePerLiter: 94.27,
      quantityLiters: 20,
      distanceKm: 5,
      surgeMultiplier: 1,
      discountPercent: 0,
    });

    expect(result.basePrice).toBe(1885.4);
    expect(result.totalAmount).toBeGreaterThan(1885.4);
  });

  it("should handle minimum order (1L)", () => {
    const result = calculatePricing({
      pricePerLiter: petrolPrice,
      quantityLiters: 1,
      distanceKm: 5,
      surgeMultiplier: 1,
      discountPercent: 0,
    });

    expect(result.basePrice).toBe(106.31);
    expect(result.totalAmount).toBeGreaterThan(106.31);
  });

  it("should handle large distance (>15km) with extra fee", () => {
    const result = calculatePricing({
      pricePerLiter: petrolPrice,
      quantityLiters: 10,
      distanceKm: 20,
      surgeMultiplier: 1,
      discountPercent: 0,
    });

    // 49 + (20-5)*10 + (20-15)*5 = 49 + 150 + 25 = 224
    expect(result.deliveryFee).toBe(224);
  });

  it("should never return negative total", () => {
    const result = calculatePricing({
      pricePerLiter: petrolPrice,
      quantityLiters: 1,
      distanceKm: 5,
      surgeMultiplier: 1,
      discountPercent: 99,
    });

    expect(result.totalAmount).toBeGreaterThanOrEqual(0);
  });
});
