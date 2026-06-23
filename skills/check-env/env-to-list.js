#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

// --------------------------------------
// 参数解析
// --------------------------------------
const args = process.argv.slice(2);

if (args.length < 1) {
  console.error(`
Usage:
  node env-to-list.js <path/to/.env>
`);
  process.exit(1);
}

const envFilePath = path.resolve(args[0]);

if (!fs.existsSync(envFilePath)) {
  console.error(`.env file not found: ${envFilePath}`);
  process.exit(1);
}

// --------------------------------------
// 读取并解析 .env
// --------------------------------------
const content = fs.readFileSync(envFilePath, "utf-8");

const keys = [];

content.split(/\r?\n/).forEach((line) => {
  const trimmed = line.trim();

  if (!trimmed) return;
  if (trimmed.startsWith("#")) return;

  const idx = trimmed.indexOf("=");
  if (idx <= 0) return;

  const key = trimmed.slice(0, idx).trim();

  // 基本合法性校验（防止奇怪行）
  if (/^[A-Z0-9_]+$/.test(key)) {
    keys.push(key);
  }
});

// --------------------------------------
// 去重 + 排序（稳定输出）
// --------------------------------------
const result = Array.from(new Set(keys)).sort();

// --------------------------------------
// 输出 JSON 字符串
// --------------------------------------
process.stdout.write(JSON.stringify(result));
