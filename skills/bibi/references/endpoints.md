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

### `POST /v1/channels/createFolder`

> Create a folder for subscribed channels

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/channels/createFolder"
```

### `POST /v1/channels/deleteFolder`

> Delete a channel folder

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/channels/deleteFolder"
```

### `GET /v1/channels/folders`

> List the folder tree of subscribed channels

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/channels/folders"
```

### `GET /v1/channels/getNote`

> Read the user's note on a channel

| Param | Type | Required | Description |
|---|---|---|---|
| `channelUrl` | string | yes |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/channels/getNote?channelUrl=<channelUrl>"
```

### `GET /v1/channels/list`

> List subscribed channels

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/channels/list"
```

### `POST /v1/channels/moveFolder`

> Move a channel folder under another folder or to root

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/channels/moveFolder"
```

### `POST /v1/channels/setFolder`

> Put a subscribed channel into a folder

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/channels/setFolder"
```

### `POST /v1/channels/setNote`

> Write the user's note on a channel

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/channels/setNote"
```

### `POST /v1/channels/setStarred`

> Mark a subscribed channel as special follow

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/channels/setStarred"
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

### `GET /v1/collections/folders`

> List the folder tree of owned collections

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/collections/folders"
```

### `GET /v1/collections/forContent`

> List the collections a saved video belongs to

| Param | Type | Required | Description |
|---|---|---|---|
| `contentId` | string | yes |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/collections/forContent?contentId=<contentId>"
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

### `POST /v1/collections/move`

> Move a collection folder under another folder or to root

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/collections/move"
```

### `POST /v1/collections/moveItems`

> Move or copy items between collections

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/collections/moveItems"
```

### `POST /v1/collections/remove`

> Delete a collection

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/collections/remove"
```

### `POST /v1/collections/removeItems`

> Remove items from a collection

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/collections/removeItems"
```

### `POST /v1/collections/update`

> Rename a collection or change its description, emoji or visibility

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/collections/update"
```

### `POST /v1/collections/updateSummary`

> Replace a collection's aggregated summary

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/collections/updateSummary"
```

### `GET /v1/feed`

> Latest videos across all subscribed channels

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

### `POST /v1/highlights/add`

> Highlight a moment of a saved video

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/highlights/add"
```

### `GET /v1/highlights/get`

> Read a saved video's highlights and AI highlight topics

| Param | Type | Required | Description |
|---|---|---|---|
| `contentId` | string | yes | Saved video id (list_saved_videos / search_saved_videos `id`). |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/highlights/get?contentId=<contentId>"
```

### `POST /v1/highlights/remove`

> Delete highlights of a saved video

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/highlights/remove"
```

### `POST /v1/highlights/setComment`

> Change the comment on a highlight

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/highlights/setComment"
```

### `GET /v1/highlights/videos`

> List saved videos that have highlights

| Param | Type | Required | Description |
|---|---|---|---|
| `source` | string | no |  |
| `limit` | integer | no |  |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/highlights/videos?source=<source>&limit=<limit>"
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

### `POST /v1/library/remove`

> Delete a saved video from the library

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/library/remove"
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

### `GET /v1/video/visuals/status`

> Get the status and keyframe screenshots of a visual analysis task

| Param | Type | Required | Description |
|---|---|---|---|
| `taskId` | string | yes | taskId returned by POST /v1/video/visuals |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/video/visuals/status?taskId=<taskId>"
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

### `POST /v1/generateImage`

> Generate or edit an image with AI (chatimg.ai)

Transform a source image with an AI model and prompt (e.g. style transfer, editing). Requires an API token (Authorization: Bearer <token>). Billing: charged from your chatimg.ai credits per image — openai: 25 credits, gpt-image-2: 50 credits, gpt-image-2.5-flare: 50 credits, gpt-image-2.5-sunburst: 50 credits, gpt-image-2.6-flare: 50 credits, gpt-image-2.6-sunburst: 50 credits, mai-image-2.6-flash: 20 credits, flux: 12 credits, gemini: 10 credits, nanobanana-pro: 30 credits, nanobanana-2-lite: 12 credits, nanobanana-2: 20 credits, nanobanana-2.1: 20 credits, grok: 30 credits, ideogram-4.5: 35 credits, seedream: 15 credits, seedream-5-flash: 12 credits, flux3: 18 credits, flux3-klein: 12 credits, krea-3: 15 credits, hy-image-3.5: 12 credits, qwen: 8 credits, qwen-image-2.1: 8 credits, qwen-image-2.1-turbo: 8 credits, qwen-image-2.1-pro: 15 credits, qwen-image-3.0: 18 credits, qwen-image-3.0-pro: 25 credits, z-image-turbo: 5 credits, flux-2-flex: 25 credits. See GET /v1/imagePricing for machine-readable pricing. Generation is asynchronous: poll GET /v1/imageStatus with the same imageUrl until status is completed. Failed generations are automatically refunded.

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ ... }' \
  "https://api.bibigpt.co/api/v1/generateImage"
```

### `GET /v1/getMvProject`

> Read one SunoMV music video project as structured JSON (progress, cast, shots, clips)

| Param | Type | Required | Description |
|---|---|---|---|
| `contentId` | string | yes | Song ID (the <id> in https://suno.bi/song/<id>) |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/getMvProject?contentId=<contentId>"
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

### `GET /v1/imagePricing`

> List available image models and their credits pricing

Machine-readable pricing for POST /v1/generateImage: per-image credits price of each model, plus one-time credits top-up packs. No authentication required.

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/imagePricing"
```

### `GET /v1/imageStatus`

> Get the status of an image generation task

Poll the status of a generation started via POST /v1/generateImage, keyed by the source imageUrl. Read-only and free of charge. When completed, `generatedImageUrl` holds the result image.

| Param | Type | Required | Description |
|---|---|---|---|
| `imageUrl` | string | yes | The source image URL passed to /v1/generateImage |

```bash
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://api.bibigpt.co/api/v1/imageStatus?imageUrl=<imageUrl>"
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
