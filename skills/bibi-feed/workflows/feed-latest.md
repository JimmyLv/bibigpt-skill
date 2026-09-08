# Workflow: Latest Feed (Subscribed Channels)

Use this when the user wants a digest of new content across all their subscribed channels — "what's new", "today's update", or a recurring daily/weekly digest.

## Triggers

- "What's new in my subscriptions?"
- "Anything new today?"
- "Daily digest of my channels"
- "我的订阅频道有什么更新"
- "最近有什么新视频"
- "Show me my feed"

## Steps

### 1. Pull latest items

```bash
bibi feed --json                                  # default: items from last 7 days, up to 20
bibi feed --since 2026-05-01 --limit 50 --json    # explicit since (ISO date)
```

API mode:
```bash
curl -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://bibigpt.co/api/v1/feed?limit=20"
```

Response:
```json
{
  "items": [
    {
      "contentId": "...",
      "channelId": "...",
      "channelTitle": "Veritasium",
      "title": "...",
      "sourceUrl": "https://...",
      "coverUrl": "...",
      "publishedAt": "2026-05-06T..."
    }
  ],
  "nextCursor": "2026-05-04T..." // ISO date of last item; pass back as ?since=
}
```

### 2. Paginate

`nextCursor` is the `publishedAt` of the last item; pass it back as `--since <nextCursor>` to fetch the next batch. Stop when `nextCursor` is `null`.

### 3. Drill in

For each interesting item, the agent can:
- Summarize: `bibi summarize <sourceUrl>`
- Get transcript: `bibi summarize <sourceUrl> --subtitle`
- Save user note: `bibi notes update --contentId <contentId> --text "..."`

## Output formatting

Group items by channel (using `channelTitle`). For each channel show 2-3 most recent titles with publish date. Skip channels that have no items in the window.

## Default window

If the user doesn't specify a date range, the API defaults to the **last 7 days**. For "today" or "this week" intents, set `--since` accordingly. For very narrow windows (last 24h), explicitly pass `--since` ISO 8601 string.

## Notes

- Feed items are videos that already have `user_contents` rows (i.e., have been seen by some user, not necessarily this user).
- The default `since` resolves to `MIN(user_channel_subscriptions.last_seen_at)` — call `feedMarkSeen` after presenting items so the next call returns only newer ones.
- `feed` is read-only and free of minute-cost — agents can poll without burning quota (still respects per-IP rate limits).
