#!/usr/bin/env node
/**
 * End-to-end smoke test: spins up the SwiftForge MCP server over stdio with a
 * real MCP client, lists tools, and exercises each one. Run: npm run smoke
 */
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";

const transport = new StdioClientTransport({ command: "node", args: ["src/index.js"] });
const client = new Client({ name: "swiftforge-smoke", version: "0.0.0" }, { capabilities: {} });

await client.connect(transport);

const tools = await client.listTools();
console.log("✓ tools:", tools.tools.map((t) => t.name).join(", "));

const cats = await client.callTool({ name: "list_categories", arguments: {} });
console.log("\n✓ list_categories:\n" + cats.content[0].text);

const list = await client.callTool({ name: "list_components", arguments: {} });
const parsed = JSON.parse(list.content[0].text);
console.log(`\n✓ list_components: ${parsed.count} components`);

const search = await client.callTool({ name: "search_components", arguments: { query: "glass card" } });
const sres = JSON.parse(search.content[0].text);
console.log(`\n✓ search_components('glass card'): ${sres.count} hits` + (sres.results[0] ? ` (top: ${sres.results[0].id})` : ""));

if (parsed.components[0]) {
  const id = parsed.components[0].id;
  const got = await client.callTool({ name: "get_component", arguments: { id } });
  console.log(`\n✓ get_component('${id}') →\n` + got.content[0].text.slice(0, 500) + "\n...");
}

await client.close();
console.log("\n✅ smoke test passed");
