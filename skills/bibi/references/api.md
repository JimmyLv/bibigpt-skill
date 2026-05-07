# BibiGPT OpenAPI Reference

Use these HTTP endpoints when the `bibi` CLI is not installed (Linux, containers, CI).

> An auto-generated companion (`references/endpoints.md`) lists every
> endpoint with curl examples — derived from the live OpenAPI spec
> ([https://bibigpt.co/api/openapi.json](https://bibigpt.co/api/openapi.json)).
> This file (`api.md`) is hand-curated for auth, decision tables, and
> agent-friendly explanations. Use both together.

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

### Saved library

#### List saved videos — `GET /v1/library/list`

Query params: `limit` (1–100, default 20), `cursor` (page number string), `channelId`, `sortBy` (`createdAt` | `updatedAt`), `sortOrder` (`asc` | `desc`).

```bash
curl -s "https://api.bibigpt.co/api/v1/library/list?limit=20" \
  -H "Authorization: Bearer $BIBI_API_TOKEN"
# → { "videos": [...], "nextCursor": "2", "total": 87 }
```

MCP tool: `list_saved_videos`.

#### Get saved video — `GET /v1/library/get`

```bash
curl -s "https://api.bibigpt.co/api/v1/library/get?id=CONTENT_ID" \
  -H "Authorization: Bearer $BIBI_API_TOKEN"
# → { "id":..., "title":..., "note":..., "summary":..., "chapters":null, "subtitles":null, ... }
```

MCP tool: `get_saved_video`. Returns chapters (when generated) and subtitles (when stored). For fresh transcripts of unstored videos, call `get_subtitle`.

#### Search saved videos — `GET /v1/library/search`

```bash
curl -s "https://api.bibigpt.co/api/v1/library/search?keyword=AI%20agents&limit=10" \
  -H "Authorization: Bearer $BIBI_API_TOKEN"
# → { "results": [{ "contentId":..., "title":..., "snippet":..., "matchType":"note" }], "count": 7 }
```

MCP tool: `search_saved_videos`. Searches title + note (ILIKE) in parallel with subtitle full-text (Postgres `websearch_to_tsquery`). Subtitle hits include the matched segment's `timestamp` so the agent can deep-link into the moment.

### Advanced tools

| Endpoint | Method | MCP tool | Notes |
|---|---|---|---|
| `/v1/video/mindmap` | POST | `generate_video_mindmap` | Markdown → `.xmind`; cached per (user, contentId) |
| `/v1/video/visuals` | POST | `extract_video_visuals` | Pro-only; rate-limited; returns taskId — poll `vision.getVideoProcessingTask` |
| `/v1/summary/byPrompt` | POST | `generate_summary_by_prompt` | Always regenerates; overwrites the user's saved note |
| `/v1/notion/status` | GET | `get_notion_status` | Read-only; check before `export_to_notion` |
| `/v1/notion/exportNote` | POST | `export_to_notion` | Creates a new page in the bound Notion database |
| `/v1/collections/chatHistory` | GET | `get_collection_chat_history` | Returns prior messages + AI-suggested questions |

All five mutations require **write** scope. Read-only tokens (`scopes: ['read']`) get 403 from the agent middleware.

```bash
# Notion connection status (works today)
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/notion/status"

# Collection chat history
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/collections/chatHistory?collectionId=..."
```

### User notes

| Endpoint | Method | MCP tool | Purpose |
|---|---|---|---|
| `/v1/notes/list` | GET | `list_notes` | List user notes (cursor-paginated) |
| `/v1/notes/get` | GET | `get_note` | Get note by contentId |
| `/v1/notes/update` | POST | `update_note` | Save / update note (write scope) |

```bash
# List
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/notes/list?limit=20"

# Update
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"contentId":"...","text":"My polished summary"}' \
  "https://api.bibigpt.co/api/v1/notes/update"
```

### Collections

| Endpoint | Method | MCP tool | Purpose |
|---|---|---|---|
| `/v1/collections/list` | GET | `list_collections` | List owned + purchased collections (`?scope=owned\|purchased\|all`) |
| `/v1/collections/get` | GET | `get_collection` | Detail incl. items + aggregatedSummary |
| `/v1/collections/create` | POST | `create_collection` | Create new collection (write scope) |
| `/v1/collections/addItem` | POST | `add_to_collection` | Add saved video to collection (write scope) |

```bash
# List owned + purchased
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/collections/list?scope=all"

# Create
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"AI Agents 2026","description":"Best of","isPublic":false}' \
  "https://api.bibigpt.co/api/v1/collections/create"
# → { "id": "..." }
```

### Feed

`GET /v1/feed` — latest items from all subscribed channels.

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/feed?limit=20"
# → { "items": [{ "contentId", "channelId", "channelTitle", "title", "sourceUrl", "coverUrl", "publishedAt" }], "nextCursor": "..." }
```

Query params: `since` (ISO 8601, default 7 days ago), `limit` (1–100, default 20), `cursor` (use `nextCursor` from prior response). MCP tool: `get_latest_feed`.

### Channel subscriptions

| Endpoint | Method | MCP tool | Purpose |
|---|---|---|---|
| `/v1/channels/list` | GET | `list_channels` | List subscribed channels |
| `/v1/channels/subscribe` | POST | `subscribe_channel` | Subscribe by URL (write scope) |
| `/v1/channels/unsubscribe` | POST | `unsubscribe_channel` | Unsubscribe by URL (write scope) |
| `/v1/channels/videos` | GET | `get_channel_videos` | Latest videos via RSS |

```bash
# List
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/channels/list"

# Subscribe (POST JSON)
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"channelUrl":"https://www.youtube.com/@VeritasiumZH"}' \
  "https://api.bibigpt.co/api/v1/channels/subscribe"

# Channel preview videos
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/channels/videos?channelUrl=https%3A%2F%2Fwww.youtube.com%2F%40VeritasiumZH&limit=10"
```

Subscribe/unsubscribe respect plan quota — 403 returned when exceeded, with upgrade-link message.

### 11. Account / Quota — `GET /v1/me`

Get the current authenticated user's account, plan, and remaining minutes. **Auth required.**

```bash
curl -s "https://api.bibigpt.co/api/v1/me" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
# → {
#     "userId": "...",
#     "email": "user@example.com",
#     "plan": {
#       "tier": "pro",        // free | plus | pro | lifetime
#       "isPaidMember": true,
#       "expiresAt": "2027-01-15T00:00:00.000Z"
#     },
#     "remainingMinutes": 1280
#   }
```

MCP tool name: `get_account_info`. Use it to inform the user before they queue heavy work, or to suggest upgrading when minutes are low.

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
