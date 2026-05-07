# Workflow: Channel Subscriptions

Use this when the user wants to manage which YouTube/Bilibili/podcast channels they're subscribed to in BibiGPT, or to preview a channel's recent videos before deciding to subscribe.

## Triggers

- "List my subscribed channels"
- "Subscribe to <channel URL>"
- "Unsubscribe from <channel>"
- "Show me the latest videos on <channel>"
- "我订阅了哪些频道"
- "把这个频道加进我的订阅"
- "取消订阅"

## Steps

### 1. List subscribed channels

```bash
bibi channels list --json
```

Returns `{ channels: [{ id, title, url, platform, logoUrl, description, lastSummarizedAt }] }`. The `platform` field is best-effort (`youtube` / `bilibili` / `xiaoyuzhou` / etc.) derived from the URL host.

### 2. Subscribe to a channel

```bash
bibi channels subscribe --channelUrl "https://www.youtube.com/@VeritasiumZH" --json
# → { "channelId": "..." }
```

Subscription is **subject to plan quota**. Free / Plus users have a lower per-account cap; Pro / Lifetime have higher. If quota is exceeded, the API returns 403 with a clear message — surface it to the user with the upgrade link.

Optional `--author "Name"` if the channel needs a manual author label.

### 3. Unsubscribe

```bash
bibi channels unsubscribe --channelUrl "https://www.youtube.com/@..." --json
# → { "success": true }
```

### 4. Preview channel videos (RSS)

```bash
bibi channels videos --channelUrl "https://www.youtube.com/@VeritasiumZH" --limit 10 --json
```

Returns `{ title, description, videos: [{ id, title, url, publishedAt, coverUrl }] }` from the RSSHub feed. Use this to preview before subscribing, or to inspect what's new on a channel without it being in the user's library yet.

## Output formatting

For lists, render a Markdown table or compact list with title + platform + lastSummarizedAt. For subscribe/unsubscribe, confirm with a one-line success line.

## Common follow-ups

- "Which channel haven't I summarized recently" → call `channels.list` and sort by `lastSummarizedAt` (when populated)
- "What's new in my feed" → use `get_latest_feed` instead, which aggregates across all subscribed channels

## Notes

- `channels.subscribe` and `channels.unsubscribe` are **mutations** and require write scope. Read-only API tokens cannot subscribe/unsubscribe.
- `lastSummarizedAt` may be `null` for newly subscribed channels with no summarized videos yet.
