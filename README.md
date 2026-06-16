<p align="center">
  <img src="assets/logo.svg" width="104" alt="SwiftForge logo">
</p>

<h1 align="center">SwiftForge MCP</h1>

[![npm version](https://img.shields.io/npm/v/swiftforge-mcp.svg)](https://www.npmjs.com/package/swiftforge-mcp)
[![license](https://img.shields.io/npm/l/swiftforge-mcp.svg)](LICENSE)
[![MCP](https://img.shields.io/badge/MCP-server-blue.svg)](https://modelcontextprotocol.io)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS%2017--26-orange.svg)](#)

**A curated, current, production-grade SwiftUI component library — served straight to your AI coding agent over MCP.**

Think [21st.dev](https://21st.dev) (curated React components for AI agents), but for **SwiftUI**.

---

## See it in action

<!-- DROP VIDEO HERE: in GitHub's web editor, click on the line below and drag in your demo .mp4 — GitHub uploads it and inserts a player automatically. -->

_A quick tour of components from the catalog (incl. iOS 26 Liquid Glass), running in the demo app._

---

## The problem

Coding agents (Claude Code, Cursor, Copilot) are *great* at logic and *mediocre* at SwiftUI. They:

- reach for **deprecated APIs** (`NavigationView`, `.foregroundColor`, `ObservableObject` everywhere)
- have **never seen iOS 26 "Liquid Glass"** (`.glassEffect`, `GlassEffectContainer`, `.buttonStyle(.glass)`) and guess wrong
- produce **bland, one-off views** instead of polished, reusable components

You end up rewriting their SwiftUI by hand. Every time.

## What SwiftForge does

SwiftForge is a tiny **MCP server** that gives your agent on-demand access to a hand-curated catalog of **modern, compile-ready SwiftUI components**. When you ask your agent to "add a glass card" or "build an onboarding flow," it pulls the real, current component instead of hallucinating one.

The value isn't the server — it's the **curated catalog**: every component uses current API only, is dark-mode + Dynamic Type friendly, includes a `#Preview`, and is reviewed for taste.

## Quick start

### Claude Code

```bash
claude mcp add swiftforge -- npx -y swiftforge-mcp
```

### Cursor / Windsurf (`~/.cursor/mcp.json` or project `.cursor/mcp.json`)

```json
{
  "mcpServers": {
    "swiftforge": {
      "command": "npx",
      "args": ["-y", "swiftforge-mcp"]
    }
  }
}
```

Full setup, example prompts, and troubleshooting: **[docs/USAGE.md](docs/USAGE.md)**.

<details>
<summary>Run from a local clone (development)</summary>

```bash
git clone <this repo> && cd swiftforge-mcp
npm install && npm run smoke
# then point your agent at: node /absolute/path/to/src/index.js
```
</details>

Then just talk to your agent:

> "Use swiftforge to add a Liquid Glass stat card to this dashboard."
> "Search swiftforge for a pull-to-refresh list and wire it to my view model."

## Demo app — the closed loop, proven

`examples/SwiftForgeDemo` is a **real iOS app** that pulls in all 96 catalog components and builds clean — proof that the full loop works (agent → swiftforge → a compiling iOS app):

```bash
npm run demo:gen      # (re)generate the demo project from the catalog
npm run demo:build    # headless xcodebuild for the iOS simulator
# or just open it:
open examples/SwiftForgeDemo/SwiftForgeDemo.xcodeproj
```

Verified `** BUILD SUCCEEDED **` on Xcode 26 / iOS 26 simulator — **including the Liquid Glass components**. The app live-renders a couple of components (paywall, OTP) and lists the full catalog.

## Tools the agent gets

| Tool | What it does |
|------|--------------|
| `list_categories` | See the catalog's categories + counts |
| `list_components` | Browse components (optionally by category) |
| `search_components` | Free-text search by what you're building |
| `get_component` | Fetch one component's full, current SwiftUI source + usage + notes |

## What's inside

**96 curated components** across 14 categories: **Buttons & Controls · Cards & Containers · Navigation & Bars · Lists & Scroll · Lists & Grids · Forms & Inputs · Charts · Effects & Liquid Glass · Feedback & Overlays · Media · Auth & Account · Animations · Layout & Scaffolding · Onboarding & Hero** — including dedicated **iOS 26 Liquid Glass** components with graceful-fallback notes.

Every component is gated through a syntax check (`scripts/validate.js`, `xcrun swiftc -parse`) and a senior-review pass that strips deprecated API.

📖 **Browse every component → [docs/CATALOG.md](docs/CATALOG.md)**

## Roadmap

- New components every release, kept current as iOS evolves.
- Missing something? [Open an issue](https://github.com/jrlingyin888/SwiftNewModules/issues) — requests drive what gets added next.

The catalog here is free and MIT.

## License

MIT (server). Catalog content © its authors.
