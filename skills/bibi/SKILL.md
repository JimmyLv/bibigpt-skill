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

Two modes are available. **Pick the one that fits the environment:**

| Mode | When to use | Auth |
|------|-------------|------|
| **CLI mode** (`bibi` command) | macOS / Windows / Linux with desktop app installed | Desktop login or `BIBI_API_TOKEN` |
| **OpenAPI mode** (HTTP calls) | Containers, CI, or any env without `bibi` CLI | `BIBI_API_TOKEN` only |

**Auto-detection**: Run the check script (`scripts/bibi-check.sh`). It will tell you which mode is available and print usage instructions.

---

## Mode A: CLI (`bibi`)

### Installation

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

**Verify**
```bash
bibi --version
```

### Authentication

After installing, log in via the desktop app once. The CLI reads the saved session automatically.

Alternatively, set an API token:
```bash
export BIBI_API_TOKEN=<token>
```

### Commands

**Important**: URLs containing `?` or `&` must be quoted to avoid shell glob errors.

```bash
# Basic summary (Markdown output to stdout)
bibi summarize "<URL>"

# Async mode — recommended for long videos (>30min)
bibi summarize "<URL>" --async

# Chapter-by-chapter summary
bibi summarize "<URL>" --chapter

# Fetch subtitles/transcript only (no AI summary)
bibi summarize "<URL>" --subtitle

# Full JSON response
bibi summarize "<URL>" --json

# Combine flags
bibi summarize "<URL>" --subtitle --json
```

```bash
# Auth management
bibi auth check
bibi auth login
bibi auth set-token <TOKEN>

# Updates
bibi check-update
bibi self-update
```

### Output

- **Default**: Markdown summary to stdout. Progress to stderr.
- **--json**: Full JSON response to stdout.

Pipe-friendly:
```bash
bibi summarize "<URL>" > summary.md
bibi summarize "<URL>" --json | jq '.summary'
```

---

## Mode B: OpenAPI (HTTP)

Use this mode on Linux, in containers, in CI pipelines, or anywhere the `bibi` CLI is not installed. These endpoints mirror exactly what the CLI does internally.

**Base URL**: `https://api.bibigpt.co/api`
**Full OpenAPI spec**: `https://bibigpt.co/api/openapi.json`

### Authentication

Two options:

**Option 1 — API Token (simplest)**

Get your token at **https://bibigpt.co/user/integration** (API Token section), then:

```bash
export BIBI_API_TOKEN="<your-token>"
```

**Option 2 — OAuth 2.0**

BibiGPT supports the standard OAuth 2.0 authorization code flow:

| Endpoint | URL |
|----------|-----|
| Authorization | `https://bibigpt.co/api/auth/authorize` |
| Token exchange | `https://bibigpt.co/api/auth/token` |

Use `bibigpt-skill` as `client_id` with redirect URI `http://localhost` or `http://127.0.0.1`.

### Required headers

Every request **MUST** include both headers:

```
Authorization: Bearer $BIBI_API_TOKEN
x-client-type: bibi-cli
```

The `x-client-type: bibi-cli` header identifies the call as `agent-skill` channel, which gives members 100 free calls/day before normal billing kicks in.

### Endpoints

#### 1. Summarize a URL — `GET /v1/summarize`

```bash
curl -s "https://api.bibigpt.co/api/v1/summarize?url=VIDEO_URL_ENCODED" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

Response:
```json
{
  "success": true,
  "id": "...",
  "service": "youtube",
  "sourceUrl": "...",
  "htmlUrl": "https://bibigpt.co/video/...",
  "summary": "Markdown summary text...",
  "costDuration": 12.5,
  "remainingTime": 3600
}
```

Add `&includeDetail=true` to get full subtitle data in the `detail` field.

#### 2. Chapter-by-chapter summary — `GET /v1/summarizeByChapter`

```bash
curl -s "https://api.bibigpt.co/api/v1/summarizeByChapter?url=VIDEO_URL_ENCODED" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

Returns `chapters` array with `start`, `end`, `content`, and `summary` for each chapter.

#### 3. Get subtitles only — `GET /v1/getSubtitle`

```bash
curl -s "https://api.bibigpt.co/api/v1/getSubtitle?url=VIDEO_URL_ENCODED" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

Returns subtitles in `detail.subtitlesArray`. Optional params: `audioLanguage`, `enabledSpeaker`.

#### 4. Async task (for long videos >30min)

```bash
# Step 1: Create task — GET /v1/createSummaryTask
curl -s "https://api.bibigpt.co/api/v1/createSummaryTask?url=VIDEO_URL_ENCODED" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
# → { "success": true, "taskId": "abc-123", "status": "processing" }

# Step 2: Poll until done (every 3s, max ~6min) — GET /v1/getSummaryTaskStatus
curl -s "https://api.bibigpt.co/api/v1/getSummaryTaskStatus?taskId=abc-123" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
# → status: "processing" | "completed" | "failed"
```

### URL encoding

URLs must be percent-encoded when passed as query params:

```bash
# Python
python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$VIDEO_URL"

# Node.js
node -e 'console.log(encodeURIComponent(process.argv[1]))' "$VIDEO_URL"
```

### Typical agent workflow

```bash
# 1. Check token
test -n "$BIBI_API_TOKEN" || { echo "Set BIBI_API_TOKEN first"; exit 1; }

# 2. Summarize
ENCODED=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$VIDEO_URL")
RESULT=$(curl -sf "https://api.bibigpt.co/api/v1/summarize?url=$ENCODED" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli")

# 3. Extract summary
echo "$RESULT" | jq -r '.summary'
```

---

## Error Handling (both modes)

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| 401 | Token expired/invalid | Re-login or refresh `BIBI_API_TOKEN` |
| 402/403 | Quota exceeded | Visit https://bibigpt.co/pricing |
| 429 | Rate limited | Wait and retry |

CLI exit codes: `0` = success, `1` = error.

## Supported URL types

YouTube, Bilibili, podcasts (Apple/Spotify/小宇宙), TikTok/Douyin, Twitter/X, Xiaohongshu, audio files, and any URL supported by BibiGPT.

## Tips

- For long videos (>30min), use async mode (CLI: `--async` / API: `createSummaryTask`).
- Use subtitle-only mode to get raw transcripts without AI summarization.
- Use `--json` (CLI) or parse JSON response (API) for structured data.
- The `chapter` mode provides section-by-section summaries — great for lectures.
