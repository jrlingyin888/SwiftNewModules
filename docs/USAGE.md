# Using SwiftForge

SwiftForge gives your AI coding agent on-demand access to a curated library of current, production-grade SwiftUI components. This guide gets you from zero to "my agent just pasted a real Liquid Glass card into my app."

## 1. What you need

- An AI coding agent that speaks **MCP**: Claude Code, Cursor, or Windsurf.
- An iOS/SwiftUI project you're working in.
- Node.js 18+ (to run the server).

## 2. Install (1 line)

### Claude Code

```bash
claude mcp add swiftforge -- npx -y swiftforge-mcp
```

### Cursor / Windsurf — add to `mcp.json`

`~/.cursor/mcp.json` (global) or `<project>/.cursor/mcp.json`:

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

> **Running from a local clone instead of npm?** Replace the command with
> `node /absolute/path/to/swiftforge-mcp/src/index.js`.

Restart your agent so it picks up the new server.

## 3. Verify it's connected

- **Claude Code:** run `/mcp` — you should see `swiftforge` with 4 tools.
- **Cursor:** Settings → MCP → `swiftforge` shows a green dot.

## 4. Use it

Just talk to your agent. It will call SwiftForge automatically when SwiftUI UI is involved:

> "Use swiftforge to add a Liquid Glass stat card to this dashboard."
> "Search swiftforge for a pull-to-refresh list and wire it to my view model."
> "I need an OTP code input — grab one from swiftforge."
> "What onboarding components does swiftforge have?"

Under the hood the agent uses these tools:

| Tool | Purpose |
|------|---------|
| `list_categories` | See categories + counts |
| `list_components` | Browse components (optionally by category) |
| `search_components` | Find components by what you're building |
| `get_component` | Get one component's full, current SwiftUI source |

## 5. Troubleshooting

- **"Cannot preview … needs -Onone":** that's an Xcode preview/build-config issue in *your* project, not SwiftForge. Previews require the **Debug** configuration (unoptimized). Select a simulator (not "Any iOS Device") and use the Debug scheme.
- **Liquid Glass components show nothing in preview:** they require **iOS 26**. Pick an **iOS 26 simulator** as the preview/run device. Each such component is gated with `@available(iOS 26, *)` and notes a fallback.
- **Agent doesn't seem to use it:** mention "swiftforge" explicitly in your prompt, and confirm it's connected (step 3).
- **Component uses an API your deployment target doesn't have:** check the component's `minIOS` (returned by `get_component`); raise your target or use the fallback noted.

## 6. Catalog

96 curated components across 14 categories — Buttons & Controls, Cards & Containers, Navigation & Bars, Lists & Scroll, Lists & Grids, Forms & Inputs, Charts, Effects & Liquid Glass, Feedback & Overlays, Media, Auth & Account, Animations, Layout & Scaffolding, Onboarding & Hero. Every component is current-API, dark-mode + Dynamic Type friendly, and ships with a `#Preview`.

See it running: open `examples/SwiftForgeDemo/SwiftForgeDemo.xcodeproj` and hit Run.
