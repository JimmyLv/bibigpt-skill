# bibigpt-skill

AI Agent skill for summarizing videos, audio, and podcasts via [BibiGPT](https://bibigpt.co).

Two ways to use:
1. **BibiGPT Desktop + CLI Skill** — install `bibi` CLI, works with Claude Code / OpenClaw / Codex
2. **Remote MCP Server** — zero install, works with any MCP client (Claude, ChatGPT, Cursor, etc.)

---

## BibiGPT Desktop + CLI Skill (Recommended)

The most powerful way — install the BibiGPT desktop app and use the `bibi` CLI skill.

### 1. Install Desktop App

- **macOS**: `brew install --cask jimmylv/bibigpt/bibigpt` ([Homebrew tap](https://github.com/JimmyLv/homebrew-bibigpt))
- **Windows**: `winget install BibiGPT --source winget` or download from [bibigpt.co/download/desktop](https://bibigpt.co/download/desktop)

Then log in via the desktop app. The CLI reads your session automatically.

### 2. Install Skill

#### Claude Code

```bash
npx skills add JimmyLv/bibigpt-skill
```

#### OpenClaw

```bash
npx skills add JimmyLv/bibigpt-skill --agents OpenClaw --yes
```

### 3. Usage

Ask your agent to summarize any video or audio URL:

```
> Summarize this video: https://www.youtube.com/watch?v=xxxxx
```

### Commands

| Command | Description |
|---------|-------------|
| `bibi summarize "<URL>"` | Summarize a video/audio URL |
| `bibi summarize "<URL>" --async` | Async mode (long videos) |
| `bibi summarize "<URL>" --chapter` | Chapter-by-chapter summary |
| `bibi summarize "<URL>" --subtitle` | Fetch subtitles/transcript only |
| `bibi summarize "<URL>" --json` | Full JSON output |
| `bibi auth check` | Check auth status |
| `bibi auth login` | Open browser to log in |
| `bibi check-update` | Check for new version |
| `bibi self-update` | Download and install latest version |

---

## Remote MCP Server (No Install Required)

BibiGPT also provides a remote MCP server at `https://bibigpt.co/api/mcp` — works with any MCP-compatible client. Streamable HTTP transport with OAuth 2.1 authentication.

### Available Tools

| Tool | Description |
|------|-------------|
| `summarize_video` | Summarize a video or podcast URL |
| `summarize_video_with_config` | Summarize with custom prompt, model, language |
| `summarize_by_chapter` | Chapter-by-chapter summary |
| `get_subtitle` | Get transcript/subtitles with timestamps |
| `create_summary_task` | Create async task for long videos |
| `get_task_status` | Check async task status |

### Claude Code

Add to `.mcp.json` in your project root:

```json
{
  "mcpServers": {
    "bibigpt": {
      "type": "http",
      "url": "https://bibigpt.co/api/mcp"
    }
  }
}
```

Or via CLI:

```bash
claude mcp add --transport http bibigpt https://bibigpt.co/api/mcp
```

### Claude Desktop

**Option A** — UI (recommended): Settings → Connectors → Add Connector → paste `https://bibigpt.co/api/mcp`

**Option B** — Config file (`~/Library/Application Support/Claude/claude_desktop_config.json` on macOS, `%APPDATA%\Claude\claude_desktop_config.json` on Windows):

```json
{
  "mcpServers": {
    "bibigpt": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://bibigpt.co/api/mcp"]
    }
  }
}
```

### Cursor

Add to `.cursor/mcp.json` in project root, or configure in Cursor Settings → MCP:

```json
{
  "mcpServers": {
    "bibigpt": {
      "url": "https://bibigpt.co/api/mcp",
      "type": "streamable-http"
    }
  }
}
```

### VS Code (GitHub Copilot)

Add `.vscode/mcp.json` in your workspace:

```json
{
  "servers": {
    "bibigpt": {
      "type": "http",
      "url": "https://bibigpt.co/api/mcp"
    }
  }
}
```

### Windsurf

Add to `~/.codeium/windsurf/mcp_config.json`:

```json
{
  "mcpServers": {
    "bibigpt": {
      "serverUrl": "https://bibigpt.co/api/mcp"
    }
  }
}
```

### ChatGPT

1. Settings → Apps & Connectors → Advanced settings → enable **Developer mode**
2. Settings → Apps & Connectors → **Create** connector
3. Enter URL: `https://bibigpt.co/api/mcp`
4. Complete OAuth authorization when prompted

### Manus

Settings → Connectors → Add Connectors → Custom MCP → +Add Custom MCP:

Enter server URL: `https://bibigpt.co/api/mcp`

### LobeChat

Settings → Plugin Settings → Custom Plugins → Quick Import JSON:

```json
{
  "type": "mcp:streamable-http",
  "url": "https://bibigpt.co/api/mcp",
  "metadata": {
    "title": "BibiGPT",
    "description": "AI Video & Audio Summarizer"
  }
}
```

### Direct API Key (Skip OAuth)

If you have a BibiGPT API key, skip OAuth and use Bearer token directly:

```bash
# List available tools
curl -X POST https://bibigpt.co/api/mcp \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'

# Summarize a video
curl -X POST https://bibigpt.co/api/mcp \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"summarize_video","arguments":{"url":"https://www.youtube.com/watch?v=xxxxx"}}}'
```

Get your API key at [bibigpt.co/settings](https://bibigpt.co/settings).

## License

MIT
