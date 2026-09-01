import { z } from "zod";

/**
 * Tests for Zod validation schemas used across the API.
 */

const phoneSchema = z.string().regex(/^\d{10}$/, "Phone must be 10 digits");
const otpSchema = z.string().regex(/^\d{6}$/, "OTP must be 6 digits");
const fuelTypeSchema = z.enum(["petrol", "diesel", "cng", "ev_charge"]);
const quantitySchema = z.number().positive().max(100);
const amountSchema = z.number().positive().max(50000);

describe("Validation Schemas", () => {
  describe("Phone validation", () => {
    it("should accept valid 10-digit phone", () => {
      expect(phoneSchema.parse("9876543210")).toBe("9876543210");
    });

    it("should reject phone with letters", () => {
      expect(() => phoneSchema.parse("98765abcde")).toThrow();
    });

    it("should reject phone with wrong length", () => {
      expect(() => phoneSchema.parse("987654321")).toThrow();
      expect(() => phoneSchema.parse("98765432101")).toThrow();
    });
  });

  describe("OTP validation", () => {
    it("should accept valid 6-digit OTP", () => {
      expect(otpSchema.parse("123456")).toBe("123456");
    });

    it("should reject non-numeric OTP", () => {
      expect(() => otpSchema.parse("abcdef")).toThrow();
    });

    it("should reject wrong length OTP", () => {
      expect(() => otpSchema.parse("12345")).toThrow();
      expect(() => otpSchema.parse("1234567")).toThrow();
    });
  });

  describe("Fuel type validation", () => {
    it("should accept valid fuel types", () => {
      expect(fuelTypeSchema.parse("petrol")).toBe("petrol");
      expect(fuelTypeSchema.parse("diesel")).toBe("diesel");
      expect(fuelTypeSchema.parse("cng")).toBe("cng");
      expect(fuelTypeSchema.parse("ev_charge")).toBe("ev_charge");
    });

    it("should reject invalid fuel types", () => {
      expect(() => fuelTypeSchema.parse("hydrogen")).toThrow();
      expect(() => fuelTypeSchema.parse("")).toThrow();
    });
  });

  describe("Quantity validation", () => {
    it("should accept valid quantities", () => {
      expect(quantitySchema.parse(1)).toBe(1);
      expect(quantitySchema.parse(50)).toBe(50);
      expect(quantitySchema.parse(100)).toBe(100);
    });

    it("should reject zero or negative", () => {
      expect(() => quantitySchema.parse(0)).toThrow();
      expect(() => quantitySchema.parse(-5)).toThrow();
    });

    it("should reject over 100", () => {
      expect(() => quantitySchema.parse(101)).toThrow();
    });
  });

  describe("Amount validation", () => {
    it("should accept valid amounts", () => {
      expect(amountSchema.parse(100)).toBe(100);
      expect(amountSchema.parse(50000)).toBe(50000);
    });

    it("should reject over 50000", () => {
      expect(() => amountSchema.parse(50001)).toThrow();
    });
  });
});
