# OpenAPI Endpoints

> **Auto-generated.** Do not edit by hand. Regenerate via:
> ```bash
> bun packages/bibigpt-core/scripts/sync-skill-endpoints.ts --write
> ```
>
> The companion `references/api.md` is hand-curated for auth, decision tables,
> and agent-friendly explanations. Use both together.

Spec: **BibiGPT OpenAPI 规范** (v1.1.0)

## agent

### `GET /v1/channel/health`

> Probe RSS health for every subscribed channel

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/channel/health"
```

### `GET /v1/channels/list`

> List subscribed channels

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/channels/list"
```

### `POST /v1/channels/subscribe`

> Subscribe to a channel by URL

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/channels/subscribe"
```

### `POST /v1/channels/unsubscribe`

> Unsubscribe from a channel

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/channels/unsubscribe"
```

### `GET /v1/channels/videos`

> Latest videos from a channel

| Param | Type | Required | Description |
|---|---|---|---|
| `channelUrl` | string | yes |  |
| `limit` | integer | no |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/channels/videos?channelUrl=<channelUrl>&limit=<limit>"
```

### `POST /v1/collections/addItem`

> Add a saved video to a collection

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/collections/addItem"
```

### `GET /v1/collections/chatHistory`

> Get cached chat history for a collection

| Param | Type | Required | Description |
|---|---|---|---|
| `collectionId` | string | yes |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/collections/chatHistory?collectionId=<collectionId>"
```

### `POST /v1/collections/create`

> Create a new collection

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/collections/create"
```

### `GET /v1/collections/get`

> Get a collection with its items

| Param | Type | Required | Description |
|---|---|---|---|
| `id` | string | yes |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/collections/get?id=<id>"
```

### `GET /v1/collections/list`

> List user collections (owned + purchased)

| Param | Type | Required | Description |
|---|---|---|---|
| `limit` | integer | no |  |
| `cursor` | string | no |  |
| `scope` | string | no |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/collections/list?limit=<limit>&cursor=<cursor>&scope=<scope>"
```

### `GET /v1/feed`

> Latest videos across all subscribed channels (live RSS)

| Param | Type | Required | Description |
|---|---|---|---|
| `since` | string | no |  |
| `limit` | integer | no |  |
| `cursor` | string | no |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/feed?since=<since>&limit=<limit>&cursor=<cursor>"
```

### `POST /v1/feed/markSeen`

> Bump last-seen cursor for one or all subscribed channels

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/feed/markSeen"
```

### `GET /v1/library/get`

> Get a saved video with summary, chapters, subtitles, note

| Param | Type | Required | Description |
|---|---|---|---|
| `id` | string | yes |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/library/get?id=<id>"
```

### `GET /v1/library/list`

> List saved videos with pagination

| Param | Type | Required | Description |
|---|---|---|---|
| `limit` | integer | no |  |
| `cursor` | string | no |  |
| `channelId` | string | no |  |
| `sortBy` | string | no |  |
| `sortOrder` | string | no |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/library/list?limit=<limit>&cursor=<cursor>&channelId=<channelId>&sortBy=<sortBy>&sortOrder=<sortOrder>"
```

### `GET /v1/library/search`

> Search across saved videos (title, subtitles, notes)

| Param | Type | Required | Description |
|---|---|---|---|
| `keyword` | string | yes |  |
| `limit` | integer | no |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/library/search?keyword=<keyword>&limit=<limit>"
```

### `GET /v1/me`

> Get current account, plan and remaining minutes

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/me"
```

### `GET /v1/notes/get`

> Get a single note by content id

| Param | Type | Required | Description |
|---|---|---|---|
| `contentId` | string | yes |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/notes/get?contentId=<contentId>"
```

### `GET /v1/notes/list`

> List user notes across all saved videos

| Param | Type | Required | Description |
|---|---|---|---|
| `limit` | integer | no |  |
| `cursor` | string | no |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/notes/list?limit=<limit>&cursor=<cursor>"
```

### `POST /v1/notes/update`

> Create or update a note for a saved video

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/notes/update"
```

### `POST /v1/notion/exportNote`

> Export a saved video summary to Notion

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/notion/exportNote"
```

### `GET /v1/notion/status`

> Check whether the user has connected Notion

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/notion/status"
```

### `POST /v1/summary/byPrompt`

> Re-summarize a saved video with a custom prompt

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/summary/byPrompt"
```

### `POST /v1/video/mindmap`

> Generate XMind mindmap from a saved video summary

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/video/mindmap"
```

### `POST /v1/video/visuals`

> Create / look up a visual analysis task for a video

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/video/visuals"
```

## open

### `GET /v1/createSummaryTask`

> Submit video summary processing task

| Param | Type | Required | Description |
|---|---|---|---|
| `url` | string | yes | The URL to the video (e.g., ?url=https://www.bilibili.com/video/BV1Sk4y1x7r2) |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/createSummaryTask?url=<url>"
```

### `GET /v1/expandUrl`

> Expand shortened video or audio URLs

| Param | Type | Required | Description |
|---|---|---|---|
| `url` | string | yes |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/expandUrl?url=<url>"
```

### `GET /v1/express`

> Rewrite video subtitles as a polished article

| Param | Type | Required | Description |
|---|---|---|---|
| `url` | string | yes | The URL to the video (e.g., ?url=https://www.bilibili.com/video/BV1Sk4y1x7r2) |
| `includeDetail` | boolean | no |  |
| `outputLanguage` | string | no |  |
| `model` | string | no |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/express?url=<url>&includeDetail=<includeDetail>&outputLanguage=<outputLanguage>&model=<model>"
```

### `GET /v1/getPolishedText`

> Polish video subtitles into readable article segments

| Param | Type | Required | Description |
|---|---|---|---|
| `url` | string | yes | The URL to the video (e.g., ?url=https://www.bilibili.com/video/BV1Sk4y1x7r2) |
| `includeDetail` | boolean | no |  |
| `keywords` | string | no |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/getPolishedText?url=<url>&includeDetail=<includeDetail>&keywords=<keywords>"
```

### `GET /v1/getSubtitle`

> Only returns the video subtitles array in detail

| Param | Type | Required | Description |
|---|---|---|---|
| `url` | string | yes | The URL to the video (e.g., ?url=https://www.bilibili.com/video/BV1Sk4y1x7r2) |
| `audioLanguage` | string | no |  |
| `transcribeProvider` | string | no |  |
| `whisperPrompt` | string | no |  |
| `apiKey` | string | no |  |
| `enabledSpeaker` | boolean | no |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/getSubtitle?url=<url>&audioLanguage=<audioLanguage>&transcribeProvider=<transcribeProvider>&whisperPrompt=<whisperPrompt>&apiKey=<apiKey>&enabledSpeaker=<enabledSpeaker>"
```

### `GET /v1/getSummaryTaskStatus`

> Check task status and get result if completed

| Param | Type | Required | Description |
|---|---|---|---|
| `taskId` | string | yes |  |
| `includeDetail` | string | no |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/getSummaryTaskStatus?taskId=<taskId>&includeDetail=<includeDetail>"
```

### `GET /v1/summarize`

> Generate video or audio summary from url

| Param | Type | Required | Description |
|---|---|---|---|
| `url` | string | yes | The URL to the video (e.g., ?url=https://www.bilibili.com/video/BV1Sk4y1x7r2) |
| `includeDetail` | boolean | no |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/summarize?url=<url>&includeDetail=<includeDetail>"
```

### `POST /v1/summarize`

> Generate video or audio summary from url (POST variant for agent payment)

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/summarize"
```

### `GET /v1/summarizeByChapter`

> Generate chapter summary for url

| Param | Type | Required | Description |
|---|---|---|---|
| `url` | string | yes | The URL to the video (e.g., ?url=https://www.bilibili.com/video/BV1Sk4y1x7r2) |
| `includeDetail` | boolean | no |  |
| `outputLanguage` | string | no |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/summarizeByChapter?url=<url>&includeDetail=<includeDetail>&outputLanguage=<outputLanguage>"
```

### `POST /v1/summarizeWithConfig`

> Generate configurable summary from url based on prompt config

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/summarizeWithConfig"
```

### `GET /version`

> Get the version of the API

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/version"
```
