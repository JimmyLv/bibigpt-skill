# bibigpt-skill

AI Agent skill for summarizing videos, audio, and podcasts via [BibiGPT](https://bibigpt.co).

Three ways to use:
1. **BibiGPT Desktop + CLI Skill** — install `bibi` CLI, works with Claude Code / OpenClaw / Codex
2. **Remote MCP Server** — zero install, works with any MCP client (Claude, ChatGPT, Cursor, etc.)
3. **OpenAPI** — direct HTTP calls for containers, CI, or custom integrations

---

## Skill Structure

```
skills/bibi/
├── SKILL.md                        # Intent router — dispatches to workflows
├── scripts/
│   └── bibi-check.sh              # Auto-detect CLI vs API mode
├── references/
│   ├── cli.md                     # CLI command reference
│   ├── api.md                     # OpenAPI endpoint reference (10 endpoints)
│   ├── installation.md            # Setup & auth guide
│   └── supported-platforms.md     # URL types & platform limits
└── workflows/
    ├── quick-summary.md           # Paste URL → get AI summary
    ├── deep-dive.md               # Chapter breakdown + follow-up Q&A
    ├── transcript-extract.md      # Subtitle/transcript extraction
    ├── article-rewrite.md         # Video → blog/公众号图文/小红书
    ├── batch-process.md           # Multi-URL batch processing
    ├── research-compile.md        # Multi-source topic synthesis
    ├── export-notes.md            # Save to Notion/Obsidian/local
    └── visual-analysis.md         # Video frame visual analysis
```

## Workflows

| Workflow | What it does | Trigger examples |
|----------|-------------|-----------------|
| **Quick Summary** | One URL → AI summary | "summarize this video", "总结" |
| **Deep Dive** | Chapter-by-chapter + Q&A | "chapter summary", "分章节总结" |
| **Transcript Extract** | Raw subtitles with timestamps | "get subtitles", "获取字幕" |
| **Article Rewrite** | Video → polished article | "turn into article", "AI改写" |
| **Batch Process** | Multiple URLs at once | "batch summarize", "批量总结" |
| **Research Compile** | Cross-source synthesis | "compare these videos", "综合分析" |
| **Export Notes** | Save to Notion/Obsidian/file | "save to Notion", "导出笔记" |
| **Visual Analysis** | Analyze slides & on-screen content | "画面分析", "what's on screen" |

---

## Quick Start

### 1. Install Desktop App

```bash
curl -fsSL https://bibigpt.co/install.sh | bash
```

Works on **macOS** (auto-uses Homebrew), **Linux** (downloads AppImage), and detects Windows (prompts to use winget).

Or install manually per platform:
- **macOS**: `brew install --cask jimmylv/bibigpt/bibigpt` ([Homebrew tap](https://github.com/JimmyLv/homebrew-bibigpt))
- **Windows**: `winget install BibiGPT --source winget` or download from [bibigpt.co/download/desktop](https://bibigpt.co/download/desktop)
- **Linux**: Download `.deb` / `.AppImage` from [bibigpt.co/download/desktop](https://bibigpt.co/download/desktop)

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

Ask your agent to summarize any video, audio URL, or **local file**:

```
> Summarize this video: https://www.youtube.com/watch?v=xxxxx
> Summarize this local file: /path/to/meeting-recording.mp4
```

The agent will automatically detect the best mode and route to the right workflow.

### Commands

| Command | Description |
|---------|-------------|
| `bibi summarize "<URL>"` | Summarize a video/audio URL |
| `bibi summarize "/path/to/file.mp4"` | Summarize a local audio/video file |
| `bibi summarize "<INPUT>" --async` | Async mode (long videos) |
| `bibi summarize "<INPUT>" --chapter` | Chapter-by-chapter summary |
| `bibi summarize "<INPUT>" --subtitle` | Fetch subtitles/transcript only |
| `bibi summarize "<INPUT>" --json` | Full JSON output |
| `bibi auth check` | Check auth status |
| `bibi auth login` | Open browser to log in |
| `bibi check-update` | Check for new version |
| `bibi self-update` | Download and install latest version |

---

### Updating

#### Update the Skill

```bash
npx skills update JimmyLv/bibigpt-skill
```

#### Update the Desktop App (CLI)

The `bibi` CLI can self-update:

```bash
bibi check-update    # check if a new version is available
bibi self-update     # download and install the latest version
```

Or reinstall via package manager:

- **macOS**: `brew upgrade --cask bibigpt`
- **Windows**: `winget upgrade BibiGPT --source winget`
- **Linux**: Download the latest `.deb` / `.AppImage` from [bibigpt.co/download/desktop](https://bibigpt.co/download/desktop)

> **Note**: The desktop app build is triggered via the `build-tauri-desktop-app` GitHub Actions workflow. After a successful build, artifacts are uploaded to OSS and the `latest.json` manifest is updated automatically — the client checks this manifest for update availability.

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

### OpenAI Codex

Edit `~/.codex/config.toml` (or `.codex/config.toml` in project root):

```toml
[mcp_servers.bibigpt]
url = "https://bibigpt.co/api/mcp"
```

With API key authentication:

```toml
[mcp_servers.bibigpt]
url = "https://bibigpt.co/api/mcp"
bearer_token_env_var = "BIBIGPT_API_KEY"
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
# List available tools (no auth needed for discovery)
curl -X POST https://bibigpt.co/api/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'

# Summarize a video (requires auth)
curl -X POST https://bibigpt.co/api/mcp \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"summarize_video","arguments":{"url":"https://www.youtube.com/watch?v=xxxxx"}}}'
```

Get your API key at [bibigpt.co/user/integration](https://bibigpt.co/user/integration).

## License

MIT
