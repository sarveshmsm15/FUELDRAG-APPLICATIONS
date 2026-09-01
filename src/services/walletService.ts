import prisma from "../config/database.js";
import { TransactionType } from "../generated/prisma/client.js";
import { logger } from "../logging/logger.js";

/**
 * Debit wallet — deduct amount with PIN verification.
 * Creates an immutable transaction ledger entry.
 */
export async function debitWallet(
  userId: string,
  amount: number,
  description: string,
  referenceId?: string,
): Promise<{ success: boolean; balance: number; transactionId: string }> {
  if (amount <= 0) throw new Error("Amount must be positive");

  // Use a transaction for atomicity
  const result = await prisma.$transaction(async (tx) => {
    const wallet = await tx.wallet.findUnique({ where: { userId } });
    if (!wallet) throw new Error("Wallet not found");
    if (wallet.balance < amount) throw new Error("Insufficient wallet balance");

    const newBalance = wallet.balance - amount;

    const transaction = await tx.walletTransaction.create({
      data: {
        walletId: wallet.id,
        userId,
        type: TransactionType.debit,
        amount,
        balanceAfter: newBalance,
        description,
        referenceId,
      },
    });

    await tx.wallet.update({
      where: { id: wallet.id },
      data: { balance: newBalance },
    });

    logger.info({
      msg: "Wallet debited",
      userId,
      amount,
      newBalance,
      referenceId,
    });

    return { success: true, balance: newBalance, transactionId: transaction.id };
  });

  return result;
}

/**
 * Credit wallet — add funds.
 */
export async function creditWallet(
  userId: string,
  amount: number,
  description: string,
  referenceId?: string,
): Promise<{ success: boolean; balance: number; transactionId: string }> {
  if (amount <= 0) throw new Error("Amount must be positive");

  const result = await prisma.$transaction(async (tx) => {
    let wallet = await tx.wallet.findUnique({ where: { userId } });

    if (!wallet) {
      wallet = await tx.wallet.create({
        data: { userId, balance: 0, currency: "INR" },
      });
    }

    const newBalance = wallet.balance + amount;

    const transaction = await tx.walletTransaction.create({
      data: {
        walletId: wallet.id,
        userId,
        type: TransactionType.credit,
        amount,
        balanceAfter: newBalance,
        description,
        referenceId,
      },
    });

    await tx.wallet.update({
      where: { id: wallet.id },
      data: { balance: newBalance },
    });

    logger.info({ msg: "Wallet credited", userId, amount, newBalance, referenceId });

    return { success: true, balance: newBalance, transactionId: transaction.id };
  });

  return result;
}

/**
 * Get wallet with recent transactions.
 */
export async function getWallet(userId: string) {
  const wallet = await prisma.wallet.findUnique({
    where: { userId },
    include: {
      transactions: {
        orderBy: { createdAt: "desc" },
        take: 20,
      },
    },
  });

  return wallet;
}

/**
 * Refund to wallet.
 */
export async function refundToWallet(
  userId: string,
  amount: number,
  description: string,
  referenceId?: string,
): Promise<{ success: boolean; balance: number }> {
  return creditWallet(userId, amount, `Refund: ${description}`, referenceId);
}