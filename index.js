import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import crypto from "crypto";
import path from "path";
import { fileURLToPath } from "url";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// ===== ESM 下的 __dirname =====
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// ===== Web UI =====
app.use(express.static(path.join(__dirname, "public")));

// ===== Citizen Registry（V0 内存态，后期接 backend/data）=====
const citizens = {};

// 创建公民 DID
app.post("/citizen/create", (req, res) => {
  const did = "did:fairverse:" + crypto.randomUUID();
  citizens[did] = {
    did,
    createdAt: Date.now(),
    memory: []
  };
  res.json({ did });
});

// 公民 AI 对话（V0 Stub）
app.post("/citizen/ask", (req, res) => {
  const { did, message } = req.body;

  if (!citizens[did]) {
    return res.status(404).json({ error: "Citizen not found" });
  }

  citizens[did].memory.push({ role: "user", content: message });

  const reply = `【Fairverse 公民 AI】我已记录你的话：${message}`;

  citizens[did].memory.push({ role: "assistant", content: reply });

  res.json({
    did,
    reply,
    memoryCount: citizens[did].memory.length
  });
});

// 健康检查
app.get("/health", (_, res) => res.send("OK"));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log("Server running on port", PORT);
});