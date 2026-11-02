---
name: bibi
description: >
  Video summarizer agent skill for Claude Code, Codex, ChatGPT, Cursor and OpenClaw.
  Summarize YouTube, Bilibili, TikTok, Twitter/X, Xiaohongshu (video and image notes),
  podcasts and any online or local video / audio; extract timestamped transcripts
  and subtitles; chapter-by-chapter summaries; optionally remix the takeaway into
  a TikTok-style vertical music video.
  Not for already-saved videos (`bibi-library`), channel feeds (`bibi-feed`), or
  slides / frames / mind maps (`bibi-vision`): sibling skills, same CLI and account.
  Triggers: "summarize this video", "what's this video about", "get transcript",
  "extract subtitles", "YouTube summary", "podcast notes", "video to notes",
  "video summarizer", "总结这个视频", "帮我看看这个视频讲了什么", "B站总结",
  "video to TikTok MV", "把视频变成 TikTok".
  Works via the bibi CLI (macOS/Windows), the hosted MCP server, or OpenAPI (Linux / no CLI).
agent_created: true
---

# BibiGPT — video summarizer agent skill (summarize / transcript / chapters)

This file is a **discovery stub, not the usage guide**. It tells you which
mode you are in and where the live docs are. The live sources always match
the current product; anything copied into this file would go stale.

This skill is **watch-video only**. Sibling skills in the same repo (same CLI,
same account): `bibi-library` (saved videos / notes / collections),
`bibi-feed` (subscribe / latest / mark seen), `bibi-vision` (frames / mind map).
Landing: https://bibigpt.co/mcp · Human install: https://bibigpt.co/agent
Quota: Plus 100/day, Pro 300/day on the agent-skill channel; extra calls use
API balance; upgrade https://bibigpt.co/shop

## 1. Detect Mode

Run `scripts/bibi-check.sh` if present, or check in order:

| Check | Mode | Notes |
|-------|------|-------|
| `command -v bibi` | **CLI** — best: local files, desktop login | macOS / Windows / Linux desktop app |
| `$BIBI_API_TOKEN` set | **API** — HTTP calls, works anywhere | token: https://bibigpt.co/user/integration |
| MCP client available | **MCP** — zero install | connect `https://bibigpt.co/api/mcp` (OAuth 2.1) |

Neither available → install the desktop app (`brew install --cask jimmylv/bibigpt/bibigpt`
on macOS, `winget install BibiGPT` on Windows, `curl -fsSL https://bibigpt.co/install.sh | bash`
on Linux) or get an API token. Details: `references/installation.md`.

## 2. Load Live Docs (per mode)

**CLI mode** — the CLI is the always-current doc source:

```bash
bibi check-update            # once per session; run `bibi upgrade` if outdated
bibi --help                  # full command surface, grouped, with examples
bibi <command> --help        # progressive help — every --help includes examples
bibi commands                # re-fetch server-defined commands (new capabilities
                             # appear here without a binary update)
```

**API mode** — the machine-readable spec is the source of truth:

```
https://bibigpt.co/api/openapi.json      # all endpoints, schemas, auth
```

`references/api.md` has curl examples but the spec wins on conflict.

**MCP mode** — connect and list tools; they are self-describing:

```
https://bibigpt.co/api/mcp               # Streamable HTTP, OAuth 2.1
```

**Latest docs without reinstalling** — this repo is served raw from GitHub:

```
https://raw.githubusercontent.com/JimmyLv/bibigpt-skill/main/skills/bibi/SKILL.md
https://raw.githubusercontent.com/JimmyLv/bibigpt-skill/main/skills/bibi/references/<name>.md
https://raw.githubusercontent.com/JimmyLv/bibigpt-skill/main/skills/bibi/workflows/<name>.md
```

If a local `workflows/` or `references/` path below is missing (embedded-only
install via `bibi skill`), fetch it from the raw URL above instead.

## 3. Intent Routing

| User Intent | Workflow |
|------------|---------|
| Summarize a video/audio URL | → `workflows/quick-summary.md` |
| Chapter-by-chapter breakdown, detailed analysis | → `workflows/deep-dive.md` |
| Get subtitles, extract transcript, raw text | → `workflows/transcript-extract.md` |
| Turn into article, blog post, 公众号图文, 小红书 | → `workflows/article-rewrite.md` |
| Turn into TikTok / Reels / Shorts-style music video | → `workflows/video-to-tiktok-mv.md` |
| Check a SunoMV music video project: progress, who appears in which shots, failed shots, project JSON | → `workflows/mv-project-read.md` |
| Process multiple URLs, batch summarize | → `workflows/batch-process.md` |
| Research a topic across multiple videos | → `workflows/research-compile.md` |
| Save to Notion, Obsidian, export notes | → `workflows/export-notes.md` |
| Analyze visual content, slides, on-screen text, mind map | → sibling skill `bibi-vision` (fallback: `workflows/visual-analysis.md` / `workflows/advanced-tools.md`) |
| Check current account, plan, or remaining minutes | → `workflows/account-check.md` |
| Browse / search saved videos, "what have I summarized" | → sibling skill `bibi-library` (fallback: `workflows/library-browse.md`) |
| Manage channel subscriptions, list/sub/unsub | → sibling skill `bibi-feed` (fallback: `workflows/channels-manage.md`) |
| What's new across my subscriptions, latest feed, daily digest | → sibling skill `bibi-feed` (fallback: `workflows/feed-latest.md`) |
| Manage collections, list/create/share saved videos as a set | → sibling skill `bibi-library` (fallback: `workflows/collections-manage.md`) |
| Manage personal notes on saved videos, edit summaries | → sibling skill `bibi-library` (fallback: `workflows/notes-manage.md`) |
| Highlights / best moments of a saved video | → sibling skill `bibi-library` (fallback: `workflows/highlights-manage.md`) |
| Custom-prompt re-summary of a **saved** item, collection chat | → sibling skill `bibi-library` (fallback: `workflows/advanced-tools.md`) |
| **HTTP 402 / "需要付款" / Alipay AI 钱包 / no token + China user** | → `references/billing-aipay.md` |

Disambiguation: intent matches more than one workflow → ask **one** clarifying
question first. Matches none → ask what they want; **do not guess**. Bare URL
with no context → default to `workflows/quick-summary.md`.

## 4. Quick One-Liners (CLI mode)

For single-command requests that don't need a full workflow — discover the
rest via `bibi --help`:

```bash
bibi summarize "<URL-or-local-file>"     # quick summary (local: .mp4 .mp3 .m4a ...)
bibi summarize "<INPUT>" --chapter       # chapter summary
bibi summarize "<INPUT>" --subtitle      # transcript only
bibi me                                  # account, plan, remaining minutes
```

URLs containing `?` or `&` must be quoted. API mode has no local-file upload —
guide the user to a public URL (OSS/S3) first, see `references/supported-platforms.md`.

## 5. Payment Fallback (HTTP 402)

If no auth is set and the user has an Alipay account, BibiGPT may respond
with HTTP `402 Payment Required` + `Payment-Needed` header (AI 收 protocol).
The bibi CLI prints a stable marker line `[HTTP/402 Payment Required]` to
stderr before any human-readable prompt. When either signal appears, route to
`references/billing-aipay.md` instead of treating the call as failed — the
agent can resolve payment automatically via
[`@alipay/agent-payment`](https://www.npmjs.com/package/@alipay/agent-payment)
or a one-off QR purchase.
