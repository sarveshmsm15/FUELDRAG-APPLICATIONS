import bcrypt from 'bcrypt';

const SALT_ROUNDS = 12;

/**
 * Hash a password or PIN using bcrypt.
 */
export async function hashPassword(plaintext: string): Promise<string> {
  return bcrypt.hash(plaintext, SALT_ROUNDS);
}

/**
 * Verify a plaintext against a bcrypt hash.
 */
export async function verifyPassword(
  plaintext: string,
  hash: string,
): Promise<boolean> {
  return bcrypt.compare(plaintext, hash);
}

/**
 * Hash a 6-digit PIN. Uses same bcrypt with 12 rounds.
 */
export async function hashPin(pin: string): Promise<string> {
  if (!/^\d{6}$/.test(pin)) {
    throw new Error('PIN must be exactly 6 digits');
  }
  return bcrypt.hash(pin, SALT_ROUNDS);
}

/**
 * Verify a PIN against its hash.
 */
export async function verifyPin(pin: string, hash: string): Promise<boolean> {
  return bcrypt.compare(pin, hash);
}