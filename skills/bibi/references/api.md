# BibiGPT OpenAPI Reference

Use these HTTP endpoints when the `bibi` CLI is not installed (Linux, containers, CI).

**Base URL**: `https://api.bibigpt.co/api`
**OpenAPI spec**: `https://bibigpt.co/api/openapi.json`
**MCP Server**: `https://bibigpt.co/api/mcp` (Streamable HTTP, OAuth 2.1)

## Authentication

Every request **MUST** include both headers:

```
Authorization: Bearer $BIBI_API_TOKEN
x-client-type: bibi-cli
```

Get your token at: **https://bibigpt.co/user/integration**

The `x-client-type: bibi-cli` header identifies agent-skill channel calls. Paid members get **100 free calls/day** before normal billing.

### OAuth 2.0

| Endpoint | URL |
|----------|-----|
| Authorization | `https://bibigpt.co/api/auth/authorize` |
| Token exchange | `https://bibigpt.co/api/auth/token` |

Use `bibigpt-skill` as `client_id` with redirect URI `http://localhost`.

## URL Encoding

URLs must be percent-encoded when passed as query params:

```bash
# Python
python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$URL"

# Node.js
node -e 'console.log(encodeURIComponent(process.argv[1]))' "$URL"
```

---

## Endpoints

### 1. Summarize — `GET /v1/summarize`

MCP tool: `summarize_video`

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `url` | string | yes | Video/audio URL |
| `includeDetail` | boolean | no | Include full subtitle data in `detail` field |

```bash
curl -s "https://api.bibigpt.co/api/v1/summarize?url=ENCODED_URL" \
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
  "summary": "Markdown summary...",
  "costDuration": 12.5,
  "remainingTime": 3600
}
```

### 2. Summarize with Config — `POST /v1/summarizeWithConfig`

MCP tool: `summarize_video_with_config`

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `url` | string | yes | Video/audio URL |
| `includeDetail` | boolean | no | Include subtitle data |
| `promptConfig.customPrompt` | string | no | Custom summary prompt |
| `promptConfig.outputLanguage` | string | no | Output language (e.g., `zh-CN`, `en-US`) |
| `promptConfig.audioLanguage` | string | no | Source audio language |
| `promptConfig.showEmoji` | boolean | no | Include emoji in output |
| `promptConfig.detailLevel` | number | no | Detail level (0-1000) |
| `promptConfig.showTimestamp` | boolean | no | Include timestamps |
| `promptConfig.isRefresh` | boolean | no | Force refresh (skip cache) |

```bash
curl -s -X POST "https://api.bibigpt.co/api/v1/summarizeWithConfig" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli" \
  -H "Content-Type: application/json" \
  -d '{"url":"VIDEO_URL","promptConfig":{"outputLanguage":"en-US","customPrompt":"Focus on key insights"}}'
```

### 3. Chapter Summary — `GET /v1/summarizeByChapter`

MCP tool: `summarize_by_chapter`

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `url` | string | yes | Video/audio URL |
| `outputLanguage` | string | no | Output language |
| `includeDetail` | boolean | no | Include subtitle data |

```bash
curl -s "https://api.bibigpt.co/api/v1/summarizeByChapter?url=ENCODED_URL" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

Response adds: `title`, `chapters` array (with `start`, `end`, `content`, `summary`), `chapterSummary`.

### 4. Get Subtitles — `GET /v1/getSubtitle`

MCP tool: `get_subtitle`

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `url` | string | yes | Video/audio URL |
| `audioLanguage` | string | no | Audio language code |
| `enabledSpeaker` | boolean | no | Enable speaker identification |

```bash
curl -s "https://api.bibigpt.co/api/v1/getSubtitle?url=ENCODED_URL" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

Subtitles returned in `detail.subtitlesArray` with timestamps.

### 5. Create Async Task — `GET /v1/createSummaryTask`

MCP tool: `create_summary_task`

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `url` | string | yes | Video/audio URL |

```bash
curl -s "https://api.bibigpt.co/api/v1/createSummaryTask?url=ENCODED_URL" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
# → { "success": true, "taskId": "abc-123", "status": "pending" }
```

### 6. Poll Task Status — `GET /v1/getSummaryTaskStatus`

MCP tool: `get_task_status`

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `taskId` | string | yes | Task ID from createSummaryTask |
| `includeDetail` | string | no | Include full detail |

```bash
# Poll every 3s, max ~6 min
curl -s "https://api.bibigpt.co/api/v1/getSummaryTaskStatus?taskId=abc-123" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
# → status: "pending" | "completed" | "failed"
```

When `status: "completed"`, the response includes the full summary result.

### 7. Polished Text — `GET /v1/getPolishedText`

Not MCP-enabled. Converts video subtitles into polished, readable paragraphs segment-by-segment.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `url` | string | yes | Video/audio URL |
| `includeDetail` | boolean | no | Include subtitle data |
| `keywords` | string | no | Keywords to improve polish accuracy |

```bash
curl -s "https://api.bibigpt.co/api/v1/getPolishedText?url=ENCODED_URL" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

Response:
```json
{
  "success": true,
  "title": "...",
  "segments": [
    {
      "startTime": 0,
      "endTime": 120,
      "chapterTitle": "Introduction",
      "polishedText": "...",
      "fromCache": false
    }
  ],
  "costDuration": 10.5,
  "remainingTime": 3600
}
```

### 8. Express Article — `GET /v1/express`

Not MCP-enabled. Generates a full polished article from video content in one call.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `url` | string | yes | Video/audio URL |
| `includeDetail` | boolean | no | Include subtitle data |
| `outputLanguage` | string | no | Output language (e.g., `zh-CN`, `en-US`) |
| `model` | string | no | AI model for generation |

```bash
curl -s "https://api.bibigpt.co/api/v1/express?url=ENCODED_URL&outputLanguage=zh-CN" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

Response:
```json
{
  "success": true,
  "title": "...",
  "article": "Full polished article in Markdown...",
  "fromCache": false,
  "costDuration": 15.0,
  "remainingTime": 3600
}
```

### 9. Expand URL — `GET /v1/expandUrl`

Resolve shortened/redirected URLs to their full form.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `url` | string | yes | Shortened URL |

```bash
curl -s "https://api.bibigpt.co/api/v1/expandUrl?url=ENCODED_SHORT_URL" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
# → { "url": "https://full-expanded-url..." }
```

### 10. Version — `GET /version`

No auth required.

```bash
curl -s "https://api.bibigpt.co/api/version"
# → { "version": "1.0.0" }
```

---

## Error Handling

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| 401 | Token expired/invalid | Re-login or refresh `BIBI_API_TOKEN` |
| 402/403 | Quota exceeded | Visit https://bibigpt.co/pricing |
| 429 | Rate limited | Wait and retry |

## Typical Agent Workflow

```bash
# 1. Check token
test -n "$BIBI_API_TOKEN" || { echo "Set BIBI_API_TOKEN first"; exit 1; }

# 2. Encode URL
ENCODED=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$VIDEO_URL")

# 3. Summarize
RESULT=$(curl -sf "https://api.bibigpt.co/api/v1/summarize?url=$ENCODED" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli")

# 4. Extract summary
echo "$RESULT" | jq -r '.summary'
```
