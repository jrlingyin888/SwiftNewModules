#!/usr/bin/env node
/**
 * SwiftForge MCP — a curated SwiftUI component library for AI coding agents.
 *
 * Exposes a small set of tools so an agent (Claude Code / Cursor) can discover
 * and pull production-grade, current SwiftUI components on demand instead of
 * hallucinating outdated API. The value is the curated catalog, not the server.
 */
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  ListToolsRequestSchema,
  CallToolRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

const __dirname = dirname(fileURLToPath(import.meta.url));
const CATALOG_PATH = join(__dirname, "..", "catalog", "components.json");

/** @typedef {{id:string,title:string,category:string,description:string,minIOS:string,tags:string[],dependencies:string[],code:string,usage:string,notes:string}} Component */

/** @returns {Component[]} */
function loadCatalog() {
  try {
    const raw = readFileSync(CATALOG_PATH, "utf8");
    const data = JSON.parse(raw);
    if (Array.isArray(data)) return data;
    if (Array.isArray(data?.components)) return data.components;
    return [];
  } catch (err) {
    process.stderr.write(`[swiftforge] failed to load catalog: ${err}\n`);
    return [];
  }
}

const CATALOG = loadCatalog();

function brief(c) {
  return {
    id: c.id,
    title: c.title,
    category: c.category,
    description: c.description,
    minIOS: c.minIOS,
    tags: c.tags ?? [],
  };
}

function categoriesWithCounts() {
  const counts = new Map();
  for (const c of CATALOG) counts.set(c.category, (counts.get(c.category) ?? 0) + 1);
  return [...counts.entries()]
    .map(([category, count]) => ({ category, count }))
    .sort((a, b) => a.category.localeCompare(b.category));
}

function searchComponents(query) {
  const q = String(query ?? "").trim().toLowerCase();
  if (!q) return CATALOG.map(brief);
  const terms = q.split(/\s+/);
  const scored = [];
  for (const c of CATALOG) {
    const hay = [c.id, c.title, c.description, c.category, ...(c.tags ?? [])]
      .join(" ")
      .toLowerCase();
    let score = 0;
    for (const t of terms) if (hay.includes(t)) score += 1;
    if (score > 0) scored.push({ score, c });
  }
  scored.sort((a, b) => b.score - a.score);
  return scored.map((s) => brief(s.c));
}

function renderComponent(c) {
  const deps = (c.dependencies ?? []).length ? c.dependencies.join(", ") : "none";
  return [
    `# ${c.title}`,
    ``,
    `- **id:** ${c.id}`,
    `- **category:** ${c.category}`,
    `- **min iOS:** ${c.minIOS}`,
    `- **tags:** ${(c.tags ?? []).join(", ")}`,
    `- **dependencies:** ${deps}`,
    ``,
    c.description,
    ``,
    c.notes ? `**Notes:** ${c.notes}\n` : ``,
    `## Component`,
    "```swift",
    c.code.trim(),
    "```",
    ``,
    c.usage ? `## Usage\n\`\`\`swift\n${c.usage.trim()}\n\`\`\`` : ``,
  ]
    .filter((x) => x !== ``)
    .join("\n");
}

const TOOLS = [
  {
    name: "list_categories",
    description:
      "List the SwiftForge component categories with how many curated SwiftUI components each holds. Call this first to see what's available.",
    inputSchema: { type: "object", properties: {}, additionalProperties: false },
  },
  {
    name: "list_components",
    description:
      "List curated SwiftUI components (id, title, category, description, minIOS, tags). Optionally filter by category. Use get_component to fetch the full source for one.",
    inputSchema: {
      type: "object",
      properties: {
        category: {
          type: "string",
          description: "Optional category filter (exact match, see list_categories).",
        },
      },
      additionalProperties: false,
    },
  },
  {
    name: "search_components",
    description:
      "Search the curated SwiftUI catalog by free text (matches title, description, tags, category). Returns brief results; follow up with get_component for full source. Prefer this when the user describes a UI need (e.g. 'glass card', 'pull to refresh', 'onboarding').",
    inputSchema: {
      type: "object",
      properties: {
        query: { type: "string", description: "What the user is trying to build." },
      },
      required: ["query"],
      additionalProperties: false,
    },
  },
  {
    name: "get_component",
    description:
      "Fetch one curated SwiftUI component by id, including full production-ready, current-API source code, usage example, and notes. Paste the returned Swift directly into the project.",
    inputSchema: {
      type: "object",
      properties: {
        id: { type: "string", description: "Component id (see list_components / search_components)." },
      },
      required: ["id"],
      additionalProperties: false,
    },
  },
];

const server = new Server(
  { name: "swiftforge", version: "0.1.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({ tools: TOOLS }));

server.setRequestHandler(CallToolRequestSchema, async (req) => {
  const { name, arguments: args = {} } = req.params;

  const text = (s) => ({ content: [{ type: "text", text: s }] });
  const json = (o) => text(JSON.stringify(o, null, 2));

  switch (name) {
    case "list_categories":
      return json({
        total: CATALOG.length,
        categories: categoriesWithCounts(),
      });

    case "list_components": {
      const cat = args.category;
      const items = (cat ? CATALOG.filter((c) => c.category === cat) : CATALOG).map(brief);
      return json({ count: items.length, components: items });
    }

    case "search_components": {
      const results = searchComponents(args.query);
      return json({ count: results.length, results });
    }

    case "get_component": {
      const c = CATALOG.find((x) => x.id === args.id);
      if (!c) {
        const suggestions = searchComponents(args.id).slice(0, 5).map((s) => s.id);
        return text(
          `No component with id "${args.id}". ` +
            (suggestions.length ? `Did you mean: ${suggestions.join(", ")}?` : `Use list_components to see ids.`)
        );
      }
      return text(renderComponent(c));
    }

    default:
      return text(`Unknown tool: ${name}`);
  }
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  process.stderr.write(
    `[swiftforge] ready — ${CATALOG.length} components across ${categoriesWithCounts().length} categories\n`
  );
}

main().catch((err) => {
  process.stderr.write(`[swiftforge] fatal: ${err}\n`);
  process.exit(1);
});
