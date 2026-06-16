# Changelog

All notable changes to SwiftForge are documented here.

## [Unreleased]
- List on MCP registries (official → auto-propagates to PulseMCP etc.).

## [0.2.1] — 2026-06-10
- Add `mcpName` to package.json for Official MCP Registry npm-ownership verification.

## [0.2.0] — 2026-06-10
- Catalog expanded to **96** components across **14** categories (added Charts, Media, Auth & Account, Animations, Layout & Scaffolding; more Liquid Glass, inputs, feedback, cards, navigation).
- README npm/MCP badges; `docs/CATALOG.md` browsable index (`npm run catalog:docs`).

## [0.1.0] — 2026-06-10
Initial release.
- MCP server with 4 tools: `list_categories`, `list_components`, `search_components`, `get_component`.
- Curated catalog of current, production-grade SwiftUI components, including iOS 26 Liquid Glass.
- Every component checked with `swiftc -parse`, scrubbed of deprecated API, ships with a `#Preview`.
- `examples/SwiftForgeDemo` — a real iOS app including every component; builds clean on Xcode 26 / iOS 26.
- Scripts: `smoke` (end-to-end MCP test), `validate` (syntax + deprecated-API gate), `demo:gen` / `demo:build`.
