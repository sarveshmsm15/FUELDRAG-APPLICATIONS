import "dotenv/config";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../src/generated/prisma/client.js";
import { FuelType, UserRole } from "../src/generated/prisma/client.js";
import bcrypt from "bcrypt";

const connectionString = process.env.DATABASE_URL!;
const adapter = new PrismaPg({ connectionString });
const prisma = new PrismaClient({ adapter });

async function main(): Promise<void> {
  console.log('🌱 Starting FUELRUSH database seed...');

  // ── Seed Fuel Rates ──
  const fuelRates = [
    { fuelType: FuelType.petrol, pricePerLiter: 106.31, region: 'default' },
    { fuelType: FuelType.diesel, pricePerLiter: 94.27, region: 'default' },
    { fuelType: FuelType.cng, pricePerLiter: 79.56, region: 'default' },
    { fuelType: FuelType.ev_charge, pricePerLiter: 8.50, region: 'default' },
  ];

  for (const rate of fuelRates) {
    await prisma.fuelRate.upsert({
      where: {
        fuelType_effectiveFrom_region: {
          fuelType: rate.fuelType,
          effectiveFrom: new Date(),
          region: rate.region,
        },
      },
      update: { pricePerLiter: rate.pricePerLiter },
      create: {
        fuelType: rate.fuelType,
        pricePerLiter: rate.pricePerLiter,
        region: rate.region,
        isActive: true,
      },
    });
  }
  console.log('✅ Fuel rates seeded');

  // ── Seed Admin User ──
  const adminPinHash = await bcrypt.hash('123456', 12);
  const admin = await prisma.user.upsert({
    where: { phone: '9999999999' },
    update: {},
    create: {
      phone: '9999999999',
      email: 'admin@fuelrush.com',
      name: 'FUELRUSH Admin',
      role: UserRole.super_admin,
      isVerified: true,
      isActive: true,
      pinHash: adminPinHash,
    },
  });
  console.log(`✅ Admin user seeded: ${admin.id}`);

  // ── Seed Test Customer ──
  const customerPinHash = await bcrypt.hash('123456', 12);
  const customer = await prisma.user.upsert({
    where: { phone: '9876543210' },
    update: {},
    create: {
      phone: '9876543210',
      email: 'customer@test.com',
      name: 'Test Customer',
      role: UserRole.customer,
      isVerified: true,
      isActive: true,
      pinHash: customerPinHash,
    },
  });
  console.log(`✅ Test customer seeded: ${customer.id}`);

  // ── Seed Customer Wallet ──
  await prisma.wallet.upsert({
    where: { userId: customer.id },
    update: {},
    create: {
      userId: customer.id,
      balance: 5000,
      currency: 'INR',
    },
  });
  console.log('✅ Customer wallet seeded with ₹5000');

  // ── Seed Customer Address ──
  await prisma.address.upsert({
    where: {
      id: 'seed-address-1',
    },
    update: {},
    create: {
      id: 'seed-address-1',
      userId: customer.id,
      label: 'Home',
      line1: '42 MG Road',
      city: 'Mumbai',
      state: 'Maharashtra',
      pincode: '400001',
      latitude: 19.0760,
      longitude: 72.8777,
      isDefault: true,
    },
  });
  console.log('✅ Customer address seeded');

  // ── Seed Customer Vehicle ──
  await prisma.vehicle.upsert({
    where: { registrationNumber: 'MH01AB1234' },
    update: {},
    create: {
      userId: customer.id,
      registrationNumber: 'MH01AB1234',
      make: 'Maruti Suzuki',
      model: 'Swift',
      year: 2023,
      fuelType: FuelType.petrol,
      tankCapacityLiters: 37,
      color: 'White',
      isDefault: true,
    },
  });
  console.log('✅ Customer vehicle seeded');

  // ── Seed Test Driver ──
  const driver = await prisma.user.upsert({
    where: { phone: '9123456780' },
    update: {},
    create: {
      phone: '9123456780',
      email: 'driver@test.com',
      name: 'Test Driver',
      role: UserRole.driver,
      isVerified: true,
      isActive: true,
      pinHash: customerPinHash,
    },
  });

  await prisma.driverProfile.upsert({
    where: { userId: driver.id },
    update: {},
    create: {
      userId: driver.id,
      licenseNumber: 'MH-2023-0012345',
      licenseExpiry: new Date('2028-12-31'),
      vehicleType: 'tanker_small',
      tankerCapacityLiters: 1000,
      currentLatitude: 19.0800,
      currentLongitude: 72.8800,
      isAvailable: true,
      kycVerified: true,
    },
  });
  console.log('✅ Test driver seeded');

  // ── Seed Promo Codes ──
  await prisma.promoCode.upsert({
    where: { code: 'FUEL50' },
    update: {},
    create: {
      code: 'FUEL50',
      description: '50% off on first order (max ₹100)',
      discountType: 'percentage',
      discountValue: 50,
      minOrderAmount: 500,
      maxDiscount: 100,
      usageLimit: 1000,
      validFrom: new Date(),
      validUntil: new Date('2027-12-31'),
      isActive: true,
    },
  });

  await prisma.promoCode.upsert({
    where: { code: 'FLAT200' },
    update: {},
    create: {
      code: 'FLAT200',
      description: 'Flat ₹200 off on orders above ₹2000',
      discountType: 'flat',
      discountValue: 200,
      minOrderAmount: 2000,
      usageLimit: 500,
      validFrom: new Date(),
      validUntil: new Date('2027-06-30'),
      isActive: true,
    },
  });
  console.log('✅ Promo codes seeded');

  console.log('🎉 FUELRUSH database seed complete!');
}

main()
  .catch((e: unknown) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });