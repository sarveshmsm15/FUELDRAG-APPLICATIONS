import crypto from 'crypto';

const ALGORITHM = 'aes-256-gcm';
const IV_LENGTH = 16;
const AUTH_TAG_LENGTH = 16;
const SALT_LENGTH = 64;
const KEY_LENGTH = 32;
const ITERATIONS = 100000;

/**
 * AES-256-GCM encryption for PII data.
 * Format: iv:authTag:ciphertext (all hex-encoded).
 */
export function encrypt(plaintext: string, keyHex: string): string {
  const key = Buffer.from(keyHex, 'hex');
  if (key.length !== KEY_LENGTH) {
    throw new Error('Encryption key must be 32 bytes (64 hex characters)');
  }

  const iv = crypto.randomBytes(IV_LENGTH);
  const cipher = crypto.createCipheriv(ALGORITHM, key, iv, {
    authTagLength: AUTH_TAG_LENGTH,
  });

  const encrypted = Buffer.concat([
    cipher.update(plaintext, 'utf8'),
    cipher.final(),
  ]);
  const authTag = cipher.getAuthTag();

  return [
    iv.toString('hex'),
    authTag.toString('hex'),
    encrypted.toString('hex'),
  ].join(':');
}

/**
 * AES-256-GCM decryption for PII data.
 */
export function decrypt(ciphertext: string, keyHex: string): string {
  const key = Buffer.from(keyHex, 'hex');
  if (key.length !== KEY_LENGTH) {
    throw new Error('Encryption key must be 32 bytes (64 hex characters)');
  }

  const parts = ciphertext.split(':');
  if (parts.length !== 3) {
    throw new Error('Invalid ciphertext format');
  }

  const iv = Buffer.from(parts[0], 'hex');
  const authTag = Buffer.from(parts[1], 'hex');
  const encrypted = Buffer.from(parts[2], 'hex');

  const decipher = crypto.createDecipheriv(ALGORITHM, key, iv, {
    authTagLength: AUTH_TAG_LENGTH,
  });
  decipher.setAuthTag(authTag);

  const decrypted = Buffer.concat([
    decipher.update(encrypted),
    decipher.final(),
  ]);

  return decrypted.toString('utf8');
}

/**
 * Derive an encryption key from a passphrase using PBKDF2.
 */
export function deriveKey(passphrase: string, salt?: string): {
  key: string;
  salt: string;
} {
  const usedSalt = salt ?? crypto.randomBytes(SALT_LENGTH).toString('hex');
  const key = crypto.pbkdf2Sync(
    passphrase,
    usedSalt,
    ITERATIONS,
    KEY_LENGTH,
    'sha512',
  );
  return {
    key: key.toString('hex'),
    salt: usedSalt,
  };
}

/**
 * Generate a random encryption key (64 hex chars).
 */
export function generateEncryptionKey(): string {
  return crypto.randomBytes(KEY_LENGTH).toString('hex');
}

/**
 * Mask PII for logging/display.
 */
export function maskPhone(phone: string): string {
  if (phone.length < 4) return '****';
  return `${phone.slice(0, 2)}*****${phone.slice(-3)}`;
}

export function maskEmail(email: string): string {
  const [name, domain] = email.split('@');
  if (!domain) return '***';
  return `${name[0]}***@${domain}`;
}

export function maskName(name: string): string {
  if (name.length <= 1) return '*';
  return `${name[0]}${'*'.repeat(Math.min(name.length - 1, 4))}`;
}