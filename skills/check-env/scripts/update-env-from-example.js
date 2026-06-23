#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

const args = process.argv.slice(2);

const getArg = (longFlag, shortFlag) => {
  const longIndex = args.indexOf(longFlag);
  if (longIndex !== -1 && args[longIndex + 1]) {
    return args[longIndex + 1];
  }

  const shortIndex = shortFlag ? args.indexOf(shortFlag) : -1;
  if (shortIndex !== -1 && args[shortIndex + 1]) {
    return args[shortIndex + 1];
  }

  return null;
};

const hasFlag = (longFlag) => args.includes(longFlag);

const examplePathArg = getArg("--example", "-e");
const envPathArg = getArg("--env", "-t");
const backupDirArg = getArg("--backup-dir", "-b");
const dryRun = hasFlag("--dry-run");

if (!examplePathArg || !envPathArg) {
  console.log(
    "Usage: node update-env-from-example.js --example <env.example> --env <.env> [--backup-dir <dir>] [--dry-run]",
  );
  process.exit(1);
}

const resolvePath = (inputPath) =>
  path.isAbsolute(inputPath) ? inputPath : path.resolve(process.cwd(), inputPath);

const examplePath = resolvePath(examplePathArg);
const envPath = resolvePath(envPathArg);
const backupDir = backupDirArg ? resolvePath(backupDirArg) : null;

if (examplePath === envPath) {
  console.error("--example and --env must point to different files.");
  process.exit(1);
}

if (!fs.existsSync(examplePath)) {
  console.error(`Example file not found: ${examplePathArg}`);
  process.exit(1);
}

const assignRegex = /^(\s*(?:export\s+)?)([A-Za-z_][A-Za-z0-9_]*)(\s*=\s*)(.*)$/;

const splitValueAndComment = (rawValue) => {
  let inSingle = false;
  let inDouble = false;
  let escaped = false;

  for (let i = 0; i < rawValue.length; i += 1) {
    const char = rawValue[i];

    if (escaped) {
      escaped = false;
      continue;
    }

    if (char === "\\" && inDouble) {
      escaped = true;
      continue;
    }

    if (char === "'" && !inDouble) {
      inSingle = !inSingle;
      continue;
    }

    if (char === '"' && !inSingle) {
      inDouble = !inDouble;
      continue;
    }

    if (char === "#" && !inSingle && !inDouble) {
      return [rawValue.slice(0, i).trimEnd(), rawValue.slice(i)];
    }
  }

  return [rawValue.trimEnd(), ""];
};

const isEmptyValue = (valueToken) => {
  const value = valueToken.trim();
  return value === "" || value === "''" || value === '""';
};

const readText = (filePath) => fs.readFileSync(filePath, "utf8");

const timestamp = () => {
  const now = new Date();
  const pad = (value) => String(value).padStart(2, "0");
  return [
    now.getFullYear(),
    pad(now.getMonth() + 1),
    pad(now.getDate()),
    "-",
    pad(now.getHours()),
    pad(now.getMinutes()),
    pad(now.getSeconds()),
  ].join("");
};

const parseValues = (content) => {
  const values = new Map();

  for (const line of content.split(/\r?\n/)) {
    const match = line.match(assignRegex);
    if (!match) {
      continue;
    }

    const key = match[2];
    const rawValue = match[4] || "";
    const [valueToken] = splitValueAndComment(rawValue);

    if (!isEmptyValue(valueToken)) {
      values.set(key, valueToken.trim());
    }
  }

  return values;
};

const exampleContent = readText(examplePath);
const envExists = fs.existsSync(envPath);
const envContent = envExists ? readText(envPath) : "";
const existingValues = parseValues(envContent);
const exampleKeys = new Set();
const restoredKeys = [];

const updatedLines = exampleContent.split(/\r?\n/).map((line) => {
  const match = line.match(assignRegex);
  if (!match) {
    return line;
  }

  const prefix = match[1];
  const key = match[2];
  const delimiter = match[3];
  const rawValue = match[4] || "";
  const [valueToken, commentPart] = splitValueAndComment(rawValue);
  const existingValue = existingValues.get(key);

  exampleKeys.add(key);

  if (!existingValue) {
    return line;
  }

  restoredKeys.push(key);
  const commentSuffix = commentPart ? ` ${commentPart}` : "";
  return `${prefix}${key}${delimiter}${existingValue}${commentSuffix}`;
});

const omittedKeys = [...existingValues.keys()].filter((key) => !exampleKeys.has(key));
const finalContent = updatedLines.join("\n");

let backupPath = null;
if (envExists) {
  const defaultBackupDir = backupDir || path.dirname(envPath);
  backupPath = path.join(defaultBackupDir, `${path.basename(envPath)}.backup.${timestamp()}`);
}

if (!dryRun) {
  if (envExists) {
    fs.mkdirSync(path.dirname(backupPath), { recursive: true });
    fs.copyFileSync(envPath, backupPath);
  }

  fs.mkdirSync(path.dirname(envPath), { recursive: true });
  const tempPath = `${envPath}.tmp.${process.pid}`;
  fs.writeFileSync(tempPath, finalContent, { encoding: "utf8", mode: 0o600 });
  fs.renameSync(tempPath, envPath);
  fs.chmodSync(envPath, envExists ? fs.statSync(backupPath).mode & 0o777 : 0o600);
}

console.log(dryRun ? "Dry run complete." : "Environment file rebuilt.");
console.log(`Example: ${examplePathArg}`);
console.log(`Target: ${envPathArg}`);
if (backupPath) {
  console.log(`Backup: ${backupPath}`);
} else {
  console.log("Backup: none; target did not exist");
}
console.log(`Restored ${restoredKeys.length} existing key(s).`);
if (restoredKeys.length > 0) {
  console.log(`Restored keys: ${restoredKeys.join(", ")}`);
}
if (omittedKeys.length > 0) {
  console.log(`Omitted old keys not present in example: ${omittedKeys.join(", ")}`);
}
