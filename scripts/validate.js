#!/usr/bin/env node
/**
 * Syntax gate: run `xcrun swiftc -parse` on every component's Swift source.
 * Catches brace/syntax errors without a full build. Also flags a few
 * known-deprecated API patterns. Run: node scripts/validate.js
 *
 * Requires Xcode command line tools (macOS). Skips gracefully if swiftc is absent.
 */
import { readFileSync, writeFileSync, mkdtempSync } from "node:fs";
import { execFileSync } from "node:child_process";
import { tmpdir } from "node:os";
import { join } from "node:path";

const catalog = JSON.parse(readFileSync(new URL("../catalog/components.json", import.meta.url), "utf8"));
const components = Array.isArray(catalog) ? catalog : catalog.components || [];

const DEPRECATED = [
  [/\bNavigationView\b/, "NavigationView → use NavigationStack"],
  [/\.foregroundColor\(/, ".foregroundColor → use .foregroundStyle"],
  [/\.accentColor\(/, ".accentColor → use .tint"],
  [/ObservableObject\b/, "ObservableObject → prefer @Observable (Observation)"],
  [/@StateObject\b/, "@StateObject → prefer @State with @Observable"],
  [/\.cornerRadius\(/, ".cornerRadius → use .clipShape(.rect(cornerRadius:))"],
];

let haveSwiftc = true;
try {
  execFileSync("xcrun", ["--find", "swiftc"], { stdio: "ignore" });
} catch {
  haveSwiftc = false;
  console.warn("⚠️  swiftc not found — skipping parse, running deprecated-API scan only.\n");
}

const dir = mkdtempSync(join(tmpdir(), "swiftforge-"));
let parseFails = 0;
let deprecatedHits = 0;

for (const c of components) {
  const issues = [];
  for (const [re, msg] of DEPRECATED) {
    if (!re.test(c.code)) continue;
    // Swift Charts marks (SectorMark/BarMark/…) have a legitimate, non-deprecated
    // .cornerRadius modifier — don't flag it in chart components.
    if (msg.startsWith(".cornerRadius") && c.code.includes("import Charts")) continue;
    issues.push(msg);
  }
  if (issues.length) {
    deprecatedHits += issues.length;
    console.log(`⚠️  ${c.id}: ${issues.join("; ")}`);
  }

  if (haveSwiftc) {
    const file = join(dir, `${c.id}.swift`);
    writeFileSync(file, c.code);
    try {
      execFileSync("xcrun", ["swiftc", "-parse", file], { stdio: "pipe" });
    } catch (err) {
      parseFails += 1;
      const out = (err.stderr?.toString() || err.stdout?.toString() || "").split("\n").slice(0, 3).join("\n");
      console.log(`❌ ${c.id} failed to parse:\n${out}`);
    }
  }
}

console.log(
  `\n${components.length} components · ${haveSwiftc ? parseFails + " parse failures" : "parse skipped"} · ${deprecatedHits} deprecated-API flags`
);
process.exit(parseFails > 0 ? 1 : 0);
