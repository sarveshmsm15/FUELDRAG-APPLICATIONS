import { Router, Request, Response } from "express";
import { PrismaClient } from "@prisma/client";
import crypto from "crypto";

const router = Router();
const prisma = new PrismaClient();

function hashPin(pin: string): string {
  return crypto.createHash("sha256").update(pin + "fuelrush_salt_2024").digest("hex");
}

// GET /security/pin-status - Check if user has PIN set
router.get("/pin-status", async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.sub;
    if (!userId) return res.status(401).json({ error: "Unauthorized" });

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { pinHash: true, securityQuestion: true, securityAnswerHash: true },
    });

    res.json({
      success: true,
      data: {
        hasPin: !!user?.pinHash,
        hasSecurityQuestion: !!user?.securityQuestion,
      },
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// POST /security/pin/setup - Set or change PIN with security question
router.post("/pin/setup", async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.sub;
    if (!userId) return res.status(401).json({ error: "Unauthorized" });

    const { pin, securityQuestion, securityAnswer } = req.body;

    if (!pin || !/^\d{4,6}$/.test(pin)) {
      return res.status(400).json({ error: "PIN must be 4-6 digits" });
    }

    const updateData: any = { pinHash: hashPin(pin) };

    if (securityQuestion && securityAnswer) {
      updateData.securityQuestion = securityQuestion;
      updateData.securityAnswerHash = hashPin(securityAnswer.toLowerCase().trim());
    }

    await prisma.user.update({
      where: { id: userId },
      data: updateData,
    });

    res.json({ success: true, data: { message: "PIN set successfully" } });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// POST /security/pin/verify - Verify PIN for app unlock
router.post("/pin/verify", async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.sub;
    if (!userId) return res.status(401).json({ error: "Unauthorized" });

    const { pin } = req.body;
    if (!pin) return res.status(400).json({ error: "PIN required" });

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { pinHash: true },
    });

    if (!user?.pinHash) {
      return res.status(400).json({ error: "No PIN set" });
    }

    const isValid = user.pinHash === hashPin(pin);
    res.json({ success: true, data: { valid: isValid } });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// POST /security/pin/disable - Disable PIN lock
router.post("/pin/disable", async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.sub;
    if (!userId) return res.status(401).json({ error: "Unauthorized" });

    const { pin } = req.body;
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { pinHash: true },
    });

    if (user?.pinHash && pin && user.pinHash !== hashPin(pin)) {
      return res.status(400).json({ error: "Invalid PIN" });
    }

    await prisma.user.update({
      where: { id: userId },
      data: { pinHash: null },
    });

    res.json({ success: true, data: { message: "PIN disabled" } });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// GET /security/question - Get the security question (not the answer)
router.get("/question", async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.sub;
    if (!userId) return res.status(401).json({ error: "Unauthorized" });

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { securityQuestion: true },
    });

    res.json({
      success: true,
      data: { question: user?.securityQuestion || null },
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// POST /security/recover - Recover PIN using security question
router.post("/recover", async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.sub;
    if (!userId) return res.status(401).json({ error: "Unauthorized" });

    const { answer, newPin } = req.body;
    if (!answer || !newPin) {
      return res.status(400).json({ error: "Answer and new PIN required" });
    }

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { securityAnswerHash: true },
    });

    if (!user?.securityAnswerHash) {
      return res.status(400).json({ error: "No security question set" });
    }

    const isValid = user.securityAnswerHash === hashPin(answer.toLowerCase().trim());
    if (!isValid) {
      return res.status(400).json({ error: "Wrong answer" });
    }

    await prisma.user.update({
      where: { id: userId },
      data: { pinHash: hashPin(newPin) },
    });

    res.json({ success: true, data: { message: "PIN reset successfully" } });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

export default router;
