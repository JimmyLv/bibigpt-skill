# Installation & Setup

## 1. Install the Skill

### Claude Code

```bash
npx skills add JimmyLv/bibigpt-skill
```

### OpenClaw / Other Agents

```bash
npx skills add JimmyLv/bibigpt-skill --agents <agent-name> --yes
```

### Cursor (manual install)

The bundled CLI can install the skill body directly:

```bash
bibi skill --install --target cursor
```

### Codex CLI (manual install)

```bash
bibi skill --install --target codex
```

For other clients, copy the `bibi skill --print` output into your skill / rules system.

## 2. Install BibiGPT Desktop App (for CLI mode)

**macOS (Homebrew)**
```bash
brew install --cask jimmylv/bibigpt/bibigpt
```

**Windows**
```
winget install BibiGPT --source winget
```

**Linux**
```bash
curl -fsSL https://bibigpt.co/install.sh | bash
```

Or download from: **https://bibigpt.co/download/desktop**

Verify:
```bash
bibi --version
```

## 3. Authentication

### Option A — CLI Login (recommended)

```bash
bibi auth login
```

Opens your browser for OAuth login, then automatically saves the API token to the CLI. No manual copy-paste needed.

### Option B — Desktop App Login

Log in via the BibiGPT desktop app GUI. The CLI reads the saved session automatically.

### Option C — API Token (manual)

1. Visit **https://bibigpt.co/user/integration** (API Token section)
2. Copy your token
3. Set environment variable:

```bash
export BIBI_API_TOKEN="<your-token>"
```

### Option D — OAuth 2.0 (programmatic)

For custom integrations:

| Endpoint | URL |
|----------|-----|
| Authorization | `https://bibigpt.co/api/auth/authorize` |
| Token exchange | `https://bibigpt.co/api/auth/token` |

Use `bibigpt-skill` or `bibigpt-desktop` as `client_id` with redirect URI `http://localhost`.

## 4. Verify Setup

```bash
# CLI mode
bibi auth check

# API mode
curl -sf "https://api.bibigpt.co/api/version" \
  -H "Authorization: Bearer $BIBI_API_TOKEN"
```

## 5. MCP Server (Alternative — No CLI Required)

BibiGPT also provides a remote MCP server for any MCP-compatible client:

**URL**: `https://bibigpt.co/api/mcp` (Streamable HTTP, OAuth 2.1)

### Claude Code
```bash
claude mcp add --transport http bibigpt https://bibigpt.co/api/mcp
```

### Cursor
Add to `.cursor/mcp.json`:
```json
{
  "mcpServers": {
    "bibigpt": { "url": "https://bibigpt.co/api/mcp", "type": "streamable-http" }
  }
}
```

### Claude Desktop
Settings → Connectors → Add Connector → paste `https://bibigpt.co/api/mcp`

### VS Code (Copilot)
Add `.vscode/mcp.json`:
```json
{
  "servers": {
    "bibigpt": { "type": "http", "url": "https://bibigpt.co/api/mcp" }
  }
}
```

See README.md for full MCP setup instructions for all clients.

## 6. Updates

BibiGPT ships **three independently updateable layers**. Pick the one that matches what you want refreshed.

### A. Skill content (workflows + references) — `npx skills`

The skill **does not auto-update** — Agents read whatever was last fetched. Re-run when you want new BibiGPT capabilities, fixed workflows, or new MCP tools surfaced:

```bash
npx skills update JimmyLv/bibigpt-skill
```

For a clean reinstall (rare, e.g. after big breaking changes):

```bash
npx skills remove JimmyLv/bibigpt-skill
npx skills add    JimmyLv/bibigpt-skill
```

The [BibiGPT changelog on GitHub Releases](https://github.com/JimmyLv/bibigpt-skill/releases) lists what each version added — useful before/after `update` to see what's new.

**Recommended cadence**: weekly, or any time the BibiGPT changelog mentions new MCP tools / agent endpoints.

### B. Bibi desktop CLI binary — `bibi self-update`

The CLI binary embeds a snapshot of `SKILL.md` (used by `bibi skill --print/--install`) and ships the manifest dispatcher (`bibi <resource> <action>`, `bibi commands`, `bibi skill`). Update both at once:

```bash
bibi check-update    # peek at the latest published version
bibi self-update     # download + install (uses brew on macOS, installer on Windows)
```

Or via your OS package manager:

| OS | Command |
|---|---|
| macOS | `brew upgrade --cask bibigpt` |
| Windows | `winget upgrade BibiGPT --source winget` |
| Linux | re-download from https://bibigpt.co/download/desktop |

> **Manifest is hot-cached, not embedded.** Even without `bibi self-update`, the CLI dispatcher fetches `https://bibigpt.co/api/cli-manifest.json` on first call (24h TTL), so newly-released agent procedures show up the next day. `bibi self-update` only matters when the dispatcher itself or the embedded `SKILL.md` changes.

### C. Remote MCP server — automatic

The MCP endpoint at `https://bibigpt.co/api/mcp` always serves the **latest** tool list (filtered by `meta.mcp.enabled`). MCP clients re-discover tools on every session — no manual update needed. If you don't see a new tool, restart your client (Claude Desktop / Cursor / etc.) to refresh its `tools/list` cache.

### Decision matrix

| You want… | Run |
|---|---|
| New workflows, refreshed Markdown docs | `npx skills update JimmyLv/bibigpt-skill` |
| New `bibi` CLI subcommand or fixed CLI bug | `bibi self-update` |
| New MCP tool exposed to your Agent client | usually nothing — restart client; otherwise `npx skills update` to refresh local docs |
| Both content and CLI | `npx skills update JimmyLv/bibigpt-skill && bibi self-update` |
