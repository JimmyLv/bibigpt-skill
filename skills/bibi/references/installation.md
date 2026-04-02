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

### Update Skill

```bash
npx skills update JimmyLv/bibigpt-skill
```

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

## 6. Update Desktop App

```bash
bibi check-update    # check for new version
bibi self-update     # install latest version
```

Or via package manager:
- **macOS**: `brew upgrade --cask bibigpt`
- **Windows**: `winget upgrade BibiGPT --source winget`
- **Linux**: Download latest from https://bibigpt.co/download/desktop
