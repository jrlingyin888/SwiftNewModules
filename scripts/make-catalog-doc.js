#!/usr/bin/env node
/**
 * Generate docs/CATALOG.md — a browsable index of every component, straight
 * from catalog/components.json. Lets people evaluate the breadth on GitHub
 * without installing, and gives each component an SEO-friendly anchor.
 * Run: npm run catalog:docs
 */
import { readFileSync, writeFileSync, mkdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..");
const comps = JSON.parse(readFileSync(join(ROOT, "catalog", "components.json"), "utf8"));

const cats = [];
for (const c of comps) if (!cats.includes(c.category)) cats.push(c.category);

const anchor = (s) => s.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "");
const esc = (s) => String(s).replace(/\|/g, "\\|");

const out = [];
out.push(`# SwiftForge Catalog`);
out.push(``);
out.push(`> Auto-generated from \`catalog/components.json\`. **${comps.length} components across ${cats.length} categories.**`);
out.push(`> Your AI agent fetches these on demand via MCP — see [README](../README.md) / [USAGE](USAGE.md).`);
out.push(``);
out.push(`## Categories`);
for (const cat of cats) {
  const n = comps.filter((c) => c.category === cat).length;
  out.push(`- [${cat}](#${anchor(cat)}) — ${n}`);
}
out.push(``);
for (const cat of cats) {
  out.push(`## ${cat}`);
  out.push(``);
  out.push(`| Component | min iOS | Deps | What it is |`);
  out.push(`| --- | --- | --- | --- |`);
  for (const c of comps.filter((x) => x.category === cat)) {
    const deps = (c.dependencies ?? []).length ? c.dependencies.join(", ") : "—";
    out.push(`| **${esc(c.title)}** <br>\`${c.id}\` | ${c.minIOS} | ${esc(deps)} | ${esc(c.description)} |`);
  }
  out.push(``);
}

mkdirSync(join(ROOT, "docs"), { recursive: true });
writeFileSync(join(ROOT, "docs", "CATALOG.md"), out.join("\n") + "\n");
console.log(`Wrote docs/CATALOG.md — ${comps.length} components, ${cats.length} categories`);
