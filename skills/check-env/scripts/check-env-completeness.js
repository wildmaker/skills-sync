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

const examplePathArg = getArg("--example", "-e");
const envPathArg = getArg("--env", "-t");

if (!examplePathArg || !envPathArg) {
  console.log("Usage: node check-env-completeness.js --example <env.example> --env <.env>");
  process.exit(1);
}

const resolvePath = (inputPath) =>
  path.isAbsolute(inputPath) ? inputPath : path.resolve(process.cwd(), inputPath);

const examplePath = resolvePath(examplePathArg);
const envPath = resolvePath(envPathArg);

if (examplePath === envPath) {
  console.error("--example and --env must point to different files.");
  process.exit(1);
}

if (!fs.existsSync(examplePath)) {
  console.error(`Example file not found: ${examplePathArg}`);
  process.exit(1);
}

if (!fs.existsSync(envPath)) {
  console.error(`Environment file not found: ${envPathArg}`);
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

const stripOuterQuotes = (value) => {
  const trimmed = value.trim();
  if (
    (trimmed.startsWith('"') && trimmed.endsWith('"')) ||
    (trimmed.startsWith("'") && trimmed.endsWith("'"))
  ) {
    return trimmed.slice(1, -1);
  }

  return trimmed;
};

const isEmptyValue = (valueToken) => {
  const value = stripOuterQuotes(valueToken);
  return value === "";
};

const isPlaceholderValue = (valueToken) => {
  const value = stripOuterQuotes(valueToken).trim();
  const upper = value.toUpperCase();

  return (
    /^<[^>]+>$/.test(value) ||
    /^__[^_].*__$/.test(value) ||
    upper === "TODO" ||
    upper === "TBD" ||
    upper === "REPLACE_ME" ||
    upper === "CHANGE_ME" ||
    upper === "CHANGEME" ||
    /^YOUR[_-]/i.test(value) ||
    /^XXX+$/i.test(value)
  );
};

const readAssignments = (filePath) => {
  const assignments = new Map();
  const content = fs.readFileSync(filePath, "utf8");

  for (const line of content.split(/\r?\n/)) {
    const match = line.match(assignRegex);
    if (!match) {
      continue;
    }

    const key = match[2];
    const rawValue = match[4] || "";
    const [valueToken, commentPart] = splitValueAndComment(rawValue);
    assignments.set(key, {
      valueToken: valueToken.trim(),
      comment: commentPart.toLowerCase(),
    });
  }

  return assignments;
};

const exampleAssignments = readAssignments(examplePath);
const envAssignments = readAssignments(envPath);
const requiredKeys = [];

for (const [key, assignment] of exampleAssignments.entries()) {
  const explicitOptional = /\boptional\b/.test(assignment.comment);
  const explicitRequired = /\brequired\b/.test(assignment.comment);

  if (explicitOptional) {
    continue;
  }

  if (
    explicitRequired ||
    isEmptyValue(assignment.valueToken) ||
    isPlaceholderValue(assignment.valueToken)
  ) {
    requiredKeys.push(key);
  }
}

const missingKeys = [];

for (const key of requiredKeys) {
  const actual = envAssignments.get(key);
  const example = exampleAssignments.get(key);

  if (!actual || isEmptyValue(actual.valueToken) || isPlaceholderValue(actual.valueToken)) {
    missingKeys.push(key);
    continue;
  }

  if (
    example &&
    isPlaceholderValue(example.valueToken) &&
    stripOuterQuotes(actual.valueToken) === stripOuterQuotes(example.valueToken)
  ) {
    missingKeys.push(key);
  }
}

console.log(`Checked ${requiredKeys.length} required key(s) from ${examplePathArg}.`);

if (missingKeys.length > 0) {
  console.log(`Missing required key(s): ${missingKeys.join(", ")}`);
  process.exit(1);
}

console.log("All required environment keys are present.");
