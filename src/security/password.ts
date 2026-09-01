import bcrypt from "bcrypt";

const SALT_ROUNDS = 12;

/**
 * Hash a password or PIN using bcrypt with 12 salt rounds.
 */
export async function hashPassword(plaintext: string): Promise<string> {
  return bcrypt.hash(plaintext, SALT_ROUNDS);
}

/**
 * Verify a plaintext password against a bcrypt hash.
 */
export async function verifyPassword(
  plaintext: string,
  hash: string,
): Promise<boolean> {
  return bcrypt.compare(plaintext, hash);
}

/**
 * Hash a 6-digit PIN. Validates format before hashing.
 */
export async function hashPin(pin: string): Promise<string> {
  if (!/^\d{6}$/.test(pin)) {
    throw new Error("PIN must be exactly 6 digits");
  }
  return bcrypt.hash(pin, SALT_ROUNDS);
}

/**
 * Verify a 6-digit PIN against its bcrypt hash.
 */
export async function verifyPin(
  pin: string,
  hash: string,
): Promise<boolean> {
  if (!/^\d{6}$/.test(pin)) {
    return false;
  }
  return bcrypt.compare(pin, hash);
}

/**
 * Check if a hash needs rehashing (e.g., salt rounds changed).
 */
export function needsRehash(hash: string): boolean {
  try {
    const rounds = parseInt(hash.split("$")[2], 10);
    return rounds < SALT_ROUNDS;
  } catch {
    return true;
  }
}