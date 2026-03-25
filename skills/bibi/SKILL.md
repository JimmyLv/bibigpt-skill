---
name: bibi
description: >
  AI video & audio summarizer. Summarize YouTube videos, Bilibili videos,
  podcasts, TikTok, Twitter/X, Xiaohongshu, and any online video or audio.
  Use when the user wants to summarize a video, extract transcripts/subtitles,
  get chapter-by-chapter summaries, or understand video content quickly.
  Triggers: "summarize this video", "what's this video about", "extract subtitles",
  "总结这个视频", "帮我看看这个视频讲了什么", "video summary", "podcast notes",
  "YouTube summary", "B站总结", "get transcript", "video to notes".
  Works via bibi CLI (macOS/Windows) or OpenAPI (Linux / any platform without CLI).
---

# BibiGPT — AI Video & Audio Summarizer

## Environment Check

Run `scripts/bibi-check.sh` first. It detects which mode is available:

| Mode | When to use | Auth |
|------|-------------|------|
| **CLI** (`bibi` command) | macOS / Windows / Linux with desktop app | Desktop login or `BIBI_API_TOKEN` |
| **OpenAPI** (HTTP calls) | Containers, CI, or any env without CLI | `BIBI_API_TOKEN` only |

If neither mode is available, see `references/installation.md` for setup instructions.

## Intent Routing

Route the user's request to the appropriate workflow:

| User Intent | Workflow |
|------------|---------|
| Summarize a video/audio URL | → `workflows/quick-summary.md` |
| Chapter-by-chapter breakdown, detailed analysis | → `workflows/deep-dive.md` |
| Get subtitles, extract transcript, raw text | → `workflows/transcript-extract.md` |
| Turn into article, blog post, 公众号图文, 小红书 | → `workflows/article-rewrite.md` |
| Process multiple URLs, batch summarize | → `workflows/batch-process.md` |
| Research a topic across multiple videos | → `workflows/research-compile.md` |
| Save to Notion, Obsidian, export notes | → `workflows/export-notes.md` |
| Analyze visual content, slides, on-screen text | → `workflows/visual-analysis.md` |

## Disambiguation

- If the user's intent matches **more than one** workflow, ask **one** clarifying question before routing.
- If it matches **none**, ask what they are trying to accomplish. **Do not guess.**
- If the user just pastes a URL with no context, default to `workflows/quick-summary.md`.

## Local File Support

The `bibi` CLI directly accepts local file paths (no upload needed):

```bash
bibi summarize "/path/to/video.mp4"
bibi summarize "/path/to/podcast.mp3"
```

For API mode (no CLI), guide the user to upload the file to a publicly accessible URL (OSS, S3, etc.) first, then pass that URL to the API. See `references/supported-platforms.md` for details.

## Direct CLI Operations

Use progressive help to discover options: `bibi --help` → `bibi summarize --help` → run.

For simple, single-command requests that don't need a full workflow:

```bash
bibi summarize "<URL>"              # Quick summary (URL or local file path)
bibi summarize "<URL>" --chapter    # Chapter summary
bibi summarize "<URL>" --subtitle   # Transcript only
bibi summarize "<URL>" --json       # Full JSON response
bibi auth check                     # Check auth status
```

See `references/cli.md` for all commands and flags.

## References

| Document | Contents |
|----------|----------|
| `references/cli.md` | All CLI commands, flags, output formats |
| `references/api.md` | OpenAPI endpoints, curl examples, response schemas |
| `references/installation.md` | Desktop app install, skill install, auth setup, MCP config |
| `references/supported-platforms.md` | Supported URL types, platform notes, duration limits |
