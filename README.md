# bibigpt-skill

AI Agent skill for summarizing videos, audio, and podcasts via [BibiGPT](https://bibigpt.co).

Two ways to use:
1. **Remote MCP Server** — zero install, works with any MCP client (Claude, ChatGPT, Cursor, etc.)
2. **CLI Skill** — install the `bibi` CLI for Claude Code / OpenClaw / Codex agents

---

## Remote MCP Server (No Install Required)

BibiGPT provides a remote MCP server at `https://bibigpt.co/api/mcp` — works with any MCP-compatible client. Streamable HTTP transport, OAuth 2.1 authentication.

### Available Tools

| Tool | Description |
|------|-------------|
| `summarize_video` | Summarize a video or podcast URL |
| `summarize_video_with_config` | Summarize with custom prompt, model, language |
| `summarize_by_chapter` | Chapter-by-chapter summary |
| `get_subtitle` | Get transcript/subtitles with timestamps |
| `create_summary_task` | Create async task for long videos |
| `get_task_status` | Check async task status |

### Claude Desktop

Add to `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) or `%APPDATA%\Claude\claude_desktop_config.json` (Windows):

```json
{
  "mcpServers": {
    "bibigpt": {
      "url": "https://bibigpt.co/api/mcp"
    }
  }
}
```

Or: Settings → Connectors → Add Connector → paste `https://bibigpt.co/api/mcp`

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
claude mcp add bibigpt --transport http --url https://bibigpt.co/api/mcp
```

### Cursor

Add to `.cursor/mcp.json` in your project root, or configure in Settings → MCP:

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

### ChatGPT

1. Go to Settings → Apps & Connectors → Advanced settings
2. Enable **Developer mode**
3. Add connector → enter `https://bibigpt.co/api/mcp`

OAuth is auto-discovered via `/.well-known/oauth-authorization-server`. Dynamic Client Registration supported.

### Manus

Settings → Connectors → Add Connectors → Custom MCP → +Add Custom MCP → Import by JSON:

```json
{
  "type": "streamable-http",
  "url": "https://bibigpt.co/api/mcp"
}
```

### LobeChat

Plugin Settings → Add MCP Server → enter URL: `https://bibigpt.co/api/mcp`

### VS Code / Windsurf / Other Editors

Add `.vscode/mcp.json` (or workspace `.mcp.json`):

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

### Direct API Key (Skip OAuth)

If you have a BibiGPT API key, you can skip OAuth and use it directly as a Bearer token:

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

---

## CLI Skill (Agent Native)

For Claude Code / OpenClaw / Codex agents that prefer running the CLI locally.

### Install

#### Claude Code

```bash
npx skills add JimmyLv/bibigpt-skill
```

#### OpenClaw

```bash
npx skills add JimmyLv/bibigpt-skill --agents OpenClaw --yes
```

### Prerequisites

Install the BibiGPT Desktop app:

- **macOS**: `brew install --cask jimmylv/bibigpt/bibigpt` ([Homebrew tap](https://github.com/JimmyLv/homebrew-bibigpt))
- **Windows**: `winget install BibiGPT --source winget` or download from [bibigpt.co/download/desktop](https://bibigpt.co/download/desktop)

Then log in via the desktop app. The CLI reads your session automatically.

### Usage

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

## License

MIT
