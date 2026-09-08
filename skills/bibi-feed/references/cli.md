# bibi-feed CLI

Same binary as the `bibi` skill. Discover the rest with `bibi --help`. Always pass `--json` when an agent will parse stdout.

```bash
bibi channels list --json
bibi channels subscribe --channelUrl "https://www.youtube.com/@..." --json
bibi channels unsubscribe --channelUrl "https://www.youtube.com/@..." --json
bibi channels videos --channelUrl "https://..." --limit 10 --json

bibi feed --json
bibi feed --since 2026-05-01 --limit 50 --json
bibi feed --cursor "2026-05-04T12:00:00Z" --json
bibi feed-mark-seen --json
bibi feed-mark-seen --channelUrl "https://..." --json
```

`subscribe` / `unsubscribe` / `feed-mark-seen` are writes. `list` / `videos` / `feed` are reads.

MCP tools: `list_channels`, `subscribe_channel`, `unsubscribe_channel`, `get_channel_videos`, `get_latest_feed`, `get_channel_health`, `mark_feed_seen`.
