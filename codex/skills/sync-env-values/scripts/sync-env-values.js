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

const sourcePath = getArg("--source", "-s");
const targetPath = getArg("--target", "-t");

if (!sourcePath || !targetPath) {
  console.log("Usage: node scripts/sync-env-values.js --source <path> --target <path>");
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

const isEmptyValue = (valueToken) =>
  valueToken === "" || valueToken === "''" || valueToken === '""';

const readLines = (filePath) => {
  const content = fs.readFileSync(filePath, "utf8");
  return { content, lines: content.split(/\r?\n/) };
};

const resolvePath = (inputPath) =>
  path.isAbsolute(inputPath) ? inputPath : path.resolve(process.cwd(), inputPath);

const sourceFilePath = resolvePath(sourcePath);
const targetFilePath = resolvePath(targetPath);

const { lines: sourceLines } = readLines(sourceFilePath);
const { content: targetContent, lines: targetLines } = readLines(targetFilePath);

const sourceValues = new Map();

for (const line of sourceLines) {
  const match = line.match(assignRegex);
  if (!match) {
    continue;
  }

  const key = match[2];
  const rawValue = match[4] || "";
  const [valueToken] = splitValueAndComment(rawValue);
  const trimmedValue = valueToken.trim();

  if (!isEmptyValue(trimmedValue)) {
    sourceValues.set(key, trimmedValue);
  }
}

const updatedKeys = [];
const updatedLines = targetLines.map((line) => {
  const match = line.match(assignRegex);
  if (!match) {
    return line;
  }

  const prefix = match[1];
  const key = match[2];
  const delimiter = match[3];
  const rawValue = match[4] || "";
  const [valueToken, commentPart] = splitValueAndComment(rawValue);
  const trimmedValue = valueToken.trim();

  if (!isEmptyValue(trimmedValue)) {
    return line;
  }

  const sourceValue = sourceValues.get(key);
  if (!sourceValue) {
    return line;
  }

  updatedKeys.push(key);
  const commentSuffix = commentPart ? ` ${commentPart}` : "";
  return `${prefix}${key}${delimiter}${sourceValue}${commentSuffix}`;
});

const finalContent = updatedLines.join("\n");
const endsWithNewline = targetContent.endsWith("\n");

fs.writeFileSync(targetFilePath, endsWithNewline ? `${finalContent}\n` : finalContent, "utf8");

console.log(`Updated ${updatedKeys.length} key(s) in ${targetPath}.`);
if (updatedKeys.length > 0) {
  console.log(updatedKeys.join(", "));
}
