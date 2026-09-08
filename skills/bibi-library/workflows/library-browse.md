# Workflow: Browse & Search Saved Library

Use this when the user asks about videos they've already summarized — listing, fetching by ID, or keyword search.

## Triggers

- "What videos have I summarized?"
- "Show my saved videos"
- "Find my summaries about <topic>"
- "我之前总结过的视频里有 X 吗？"
- "列出我最近的总结"
- "search my notes for <keyword>"

## Steps

### 1. List saved videos (paginated)

```bash
bibi library list --json                          # default: 20 items, sorted by updatedAt desc
bibi library list --limit 50 --json
bibi library list --channelId "<authorId>" --json # filter by channel
bibi library list --cursor "2" --json             # next page (cursor is page number)
```

Or via API:
```bash
curl -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://bibigpt.co/api/v1/library/list?limit=20"
```

Response:
```json
{
  "videos": [
    {
      "id": "...",
      "title": "...",
      "sourceUrl": "https://...",
      "coverUrl": "...",
      "duration": 1234,
      "channelId": "...",
      "channelTitle": "...",
      "createdAt": "2026-04-..."
    }
  ],
  "nextCursor": "2",
  "total": 87
}
```

### 2. Get a single saved video with note

```bash
bibi library get --id "<contentId>" --json
```

Returns the user's saved note (their personalized summary), chapters (when generated), and subtitles (when stored). For fresh transcripts of unstored videos, call `get_subtitle` (`bibi summarize <URL> --subtitle`).

### 3. Search saved videos

```bash
bibi library search --keyword "AI agents" --limit 10 --json
```

Searches title and note (ILIKE) in parallel with subtitle full-text (Postgres `websearch_to_tsquery`). Subtitle hits include the matched segment's `timestamp` so you can deep-link into a specific moment. Each result has a snippet excerpt around the match and `matchType` ∈ `title | subtitle | note | summary`.

## Output formatting

Render results as a Markdown table or list, using `title` as the link text and `sourceUrl` as the href. Highlight `channelTitle` and `createdAt`.

## Pagination

Library is sorted by `updatedAt desc` by default. Use `nextCursor` (string, treat as opaque) to fetch the next page:

```bash
bibi library list --cursor <nextCursor> --json
```

Stop when `nextCursor` is `null`.

## Common follow-ups

- User says "summarize this one again" → take `sourceUrl` from a list item, call `bibi summarize <URL>`
- User says "what was that video about X" → `library.search --keyword X`, then `library.get --id <id>` on the most relevant hit
