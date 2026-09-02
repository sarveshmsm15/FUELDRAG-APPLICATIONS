/**
 * Tests for validation logic used across the API.
 * Pure functions — no external dependencies needed.
 */

function validatePhone(phone: string): boolean {
  return /^\d{10}$/.test(phone);
}

function validateOtp(otp: string): boolean {
  return /^\d{6}$/.test(otp);
}

function validateFuelType(type: string): boolean {
  return ["petrol", "diesel", "cng", "ev_charge"].includes(type);
}

function validateQuantity(qty: number): boolean {
  return qty > 0 && qty <= 100;
}

function validateAmount(amount: number): boolean {
  return amount > 0 && amount <= 50000;
}

describe("Validation Logic", () => {
  describe("Phone validation", () => {
    it("should accept valid 10-digit phone", () => {
      expect(validatePhone("9876543210")).toBe(true);
    });

    it("should reject phone with letters", () => {
      expect(validatePhone("98765abcde")).toBe(false);
    });

    it("should reject wrong length", () => {
      expect(validatePhone("987654321")).toBe(false);
      expect(validatePhone("98765432101")).toBe(false);
    });

    it("should reject empty string", () => {
      expect(validatePhone("")).toBe(false);
    });
  });

  describe("OTP validation", () => {
    it("should accept valid 6-digit OTP", () => {
      expect(validateOtp("123456")).toBe(true);
      expect(validateOtp("000000")).toBe(true);
    });

    it("should reject non-numeric OTP", () => {
      expect(validateOtp("abcdef")).toBe(false);
      expect(validateOtp("12ab56")).toBe(false);
    });

    it("should reject wrong length", () => {
      expect(validateOtp("12345")).toBe(false);
      expect(validateOtp("1234567")).toBe(false);
    });
  });

  describe("Fuel type validation", () => {
    it("should accept all valid fuel types", () => {
      expect(validateFuelType("petrol")).toBe(true);
      expect(validateFuelType("diesel")).toBe(true);
      expect(validateFuelType("cng")).toBe(true);
      expect(validateFuelType("ev_charge")).toBe(true);
    });

    it("should reject invalid fuel types", () => {
      expect(validateFuelType("hydrogen")).toBe(false);
      expect(validateFuelType("")).toBe(false);
      expect(validateFuelType("PETROL")).toBe(false); // case sensitive
    });
  });

  describe("Quantity validation", () => {
    it("should accept valid quantities", () => {
      expect(validateQuantity(1)).toBe(true);
      expect(validateQuantity(50)).toBe(true);
      expect(validateQuantity(100)).toBe(true);
    });

    it("should reject zero or negative", () => {
      expect(validateQuantity(0)).toBe(false);
      expect(validateQuantity(-5)).toBe(false);
    });

    it("should reject over 100", () => {
      expect(validateQuantity(101)).toBe(false);
      expect(validateQuantity(1000)).toBe(false);
    });

    it("should accept decimal quantities", () => {
      expect(validateQuantity(5.5)).toBe(true);
    });
  });

  describe("Amount validation", () => {
    it("should accept valid amounts", () => {
      expect(validateAmount(100)).toBe(true);
      expect(validateAmount(50000)).toBe(true);
      expect(validateAmount(1)).toBe(true);
    });

    it("should reject over 50000", () => {
      expect(validateAmount(50001)).toBe(false);
    });

    it("should reject zero or negative", () => {
      expect(validateAmount(0)).toBe(false);
      expect(validateAmount(-100)).toBe(false);
    });
  });
});
