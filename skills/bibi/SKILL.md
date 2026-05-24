---
name: bibi
description: >
  AI video & audio summarizer + repackager. Summarize YouTube, Bilibili,
  podcasts, TikTok, Twitter/X, Xiaohongshu, and any online video or audio,
  then optionally turn the takeaway into a TikTok-style vertical music video.
  Use when the user wants to summarize a video, extract transcripts/subtitles,
  get chapter-by-chapter summaries, understand video content quickly, or
  remix a long-form video into a short vertical MV.
  Triggers: "summarize this video", "what's this video about", "extract subtitles",
  "总结这个视频", "帮我看看这个视频讲了什么", "video summary", "podcast notes",
  "YouTube summary", "B站总结", "get transcript", "video to notes",
  "video to TikTok MV", "把视频变成 TikTok", "video to song", "做一个 TikTok 视频".
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

**Payment fallback (China)**: if neither auth is set but the user has an Alipay
account, BibiGPT may emit HTTP `402 Payment Required` with a `Payment-Needed`
header (AI 收 protocol). The agent can resolve this automatically by installing
[`@alipay/agent-payment`](https://www.npmjs.com/package/@alipay/agent-payment),
or manually by directing the user to a one-off QR purchase. See
`references/billing-aipay.md`.

**Detect 402 deterministically**: the bibi CLI prints a stable marker line
`[HTTP/402 Payment Required]` to stderr before any human-readable prompt; direct
HTTP callers get status `402` + `Payment-Needed` header. When either signal
appears, route to `references/billing-aipay.md` instead of treating the call
as failed.

## Intent Routing

Route the user's request to the appropriate workflow:

| User Intent | Workflow |
|------------|---------|
| Summarize a video/audio URL | → `workflows/quick-summary.md` |
| Chapter-by-chapter breakdown, detailed analysis | → `workflows/deep-dive.md` |
| Get subtitles, extract transcript, raw text | → `workflows/transcript-extract.md` |
| Turn into article, blog post, 公众号图文, 小红书 | → `workflows/article-rewrite.md` |
| Turn into TikTok / Reels / Shorts-style music video | → `workflows/video-to-tiktok-mv.md` |
| Process multiple URLs, batch summarize | → `workflows/batch-process.md` |
| Research a topic across multiple videos | → `workflows/research-compile.md` |
| Save to Notion, Obsidian, export notes | → `workflows/export-notes.md` |
| Analyze visual content, slides, on-screen text | → `workflows/visual-analysis.md` |
| Check current account, plan, or remaining minutes | → `workflows/account-check.md` |
| Browse / search saved videos, "what have I summarized" | → `workflows/library-browse.md` |
| Manage channel subscriptions, list/sub/unsub, RSS preview | → `workflows/channels-manage.md` |
| What's new across my subscriptions, latest feed, daily digest | → `workflows/feed-latest.md` |
| Manage collections, list/create/share saved videos as a set | → `workflows/collections-manage.md` |
| Manage personal notes on saved videos, edit summaries | → `workflows/notes-manage.md` |
| Generate mindmap, visual analysis, custom-prompt summary, Notion export, collection chat | → `workflows/advanced-tools.md` |
| **HTTP 402 / "需要付款" / Alipay AI 钱包 / no token + China user** | → `references/billing-aipay.md` |

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
bibi me                             # Get account, plan, remaining minutes
bibi commands                       # List all manifest-driven commands
```

See `references/cli.md` for all commands and flags.

## References

| Document | Contents |
|----------|----------|
| `references/cli.md` | All CLI commands, flags, output formats |
| `references/api.md` | OpenAPI endpoints, curl examples, response schemas |
| `references/installation.md` | Desktop app install, skill install, auth setup, MCP config |
| `references/supported-platforms.md` | Supported URL types, platform notes, duration limits |
| `references/billing-aipay.md` | Alipay AI收 (HTTP 402) per-call payment fallback for China users |
