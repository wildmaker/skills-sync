#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

// --------------------------------------------------
// 参数解析（无参数名模式）
// --------------------------------------------------
const args = process.argv.slice(2);

if (args.length < 2) {
  console.error(`
Usage:
  node check-env.js '<json-array-of-env-keys>' <path/to/.env>

Example:
  node check-env.js '["OPENAI_API_KEY","OPENAI_MODEL"]' ./backend/.env
`);
  process.exit(1);
}

let requiredVars;
try {
  requiredVars = JSON.parse(args[0]);
  if (!Array.isArray(requiredVars)) {
    throw new Error("Env spec must be an array");
  }
} catch (err) {
  console.error("Failed to parse env spec JSON:");
  console.error(err.message);
  process.exit(1);
}

const envFilePath = path.resolve(args[1]);

if (!fs.existsSync(envFilePath)) {
  console.error(`.env file not found: ${envFilePath}`);
  process.exit(1);
}

// --------------------------------------------------
// 读取并解析 .env
// --------------------------------------------------
const envContent = fs.readFileSync(envFilePath, "utf-8");

const existingVars = new Set();

envContent.split(/\r?\n/).forEach((line) => {
  const trimmed = line.trim();
  if (!trimmed || trimmed.startsWith("#")) return;

  const idx = trimmed.indexOf("=");
  if (idx > 0) {
    const key = trimmed.slice(0, idx).trim();
    existingVars.add(key);
  }
});

// --------------------------------------------------
// 计算缺失变量
// --------------------------------------------------
const missingVars = requiredVars.filter(
  (key) => typeof key === "string" && !existingVars.has(key)
);

if (missingVars.length === 0) {
  console.log("All required environment variables are present.");
  process.exit(0);
}

// --------------------------------------------------
// 构造追加内容
// --------------------------------------------------
const now = new Date().toISOString();

let appendBlock = `
# ==================================================
# Auto-added missing environment variables
# Generated at: ${now}
# Please review and fill in the values below
# ==================================================

`;

for (const key of missingVars) {
  appendBlock += `# TODO: ${key} is missing\n`;
  appendBlock += `${key}=\n\n`;
}

// --------------------------------------------------
// 写回 .env（仅追加）
// --------------------------------------------------
fs.appendFileSync(envFilePath, appendBlock);

console.log(`Added ${missingVars.length} missing env variables:`);
missingVars.forEach((v) => console.log(`  - ${v}`));
