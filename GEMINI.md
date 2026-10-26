# BibiGPT

The `bibigpt` MCP server (`https://bibigpt.co/api/mcp`) summarizes, transcribes and searches
YouTube, Bilibili, TikTok, Twitter/X, Xiaohongshu, podcasts and other video / audio URLs.
Sign in once with `/mcp auth bibigpt` (OAuth, no API key to paste).

- One video, default summary: `summarize_video` with the URL.
- Transcript only (fastest): `get_subtitle`.
- Custom prompt, output language or format: `generate_summary_by_prompt`.
- Videos the user already saved: `list_saved_videos`, `search_saved_videos`, `get_saved_video`.
- Channel tracking: `subscribe_channel` / `unsubscribe_channel`.
- Public videos only. On a 402 / quota error, tell the user and point them to https://bibigpt.co/shop.

The skills in `skills/` cover each workflow step by step: `bibi` (watch a new video),
`bibi-library` (saved videos, notes, collections), `bibi-feed` (channels and latest videos),
`bibi-vision` (frames, slides, mind map).
