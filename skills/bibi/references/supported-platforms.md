# Supported Platforms & URL Types

## Supported Platforms

| Platform | Example URLs | Notes |
|----------|-------------|-------|
| **YouTube** | `youtube.com/watch?v=xxx`, `youtu.be/xxx`, `youtube.com/shorts/xxx` | Long-form, shorts, live recordings |
| **Bilibili** (B站) | `bilibili.com/video/BVxxx`, `b23.tv/xxx` | BV format; b23.tv short links auto-expanded |
| **Apple Podcasts** | `podcasts.apple.com/...` | Episode pages |
| **Spotify** | `open.spotify.com/episode/...` | Episode pages |
| **小宇宙** (Xiaoyuzhou) | `xiaoyuzhoufm.com/episode/...` | Chinese podcast platform |
| **TikTok / Douyin** | `tiktok.com/@user/video/xxx`, `douyin.com/...` | Short-form video |
| **Twitter / X** | `twitter.com/.../status/xxx`, `x.com/.../status/xxx` | Video tweets |
| **Xiaohongshu** (小红书) | `xiaohongshu.com/explore/xxx`, `xhslink.com/xxx` | Video notes |
| **Generic audio/video** | Direct `.mp3`, `.mp4`, `.wav` URLs | Any publicly accessible media URL |

## Duration & Async Mode

| Duration | Recommended Mode | CLI Flag | API Endpoint |
|----------|-----------------|----------|--------------|
| < 30 min | Synchronous | (default) | `GET /v1/summarize` |
| > 30 min | Async | `--async` | `GET /v1/createSummaryTask` + poll |

Async mode creates a background task. Poll `getSummaryTaskStatus` every 3 seconds until `status: "completed"` (max ~6 min).

## Language Support

- **Auto-detection**: BibiGPT detects the audio language automatically
- **Subtitle languages**: Supports all languages available on the platform
- **Output language**: Configurable via `outputLanguage` param (e.g., `zh-CN`, `en-US`, `ja`, `ko`)
- **Speaker identification**: Enable with `enabledSpeaker=true` (API) for multi-speaker content

## File Upload

The BibiGPT desktop app supports local file upload:
- Audio: `.mp3`, `.wav`, `.m4a`, `.flac`, `.ogg`
- Video: `.mp4`, `.mkv`, `.avi`, `.mov`, `.webm`

File upload is only available through the desktop app UI, not via CLI or API.

## Platform-Specific Notes

- **Bilibili**: Short links (`b23.tv/xxx`) are auto-expanded. Use `expandUrl` API if you need the full URL first
- **Twitter/X**: Only video tweets are supported; text-only tweets return an error
- **Xiaohongshu**: Short links (`xhslink.com/xxx`) are auto-expanded
- **Podcasts**: All three podcast platforms (Apple, Spotify, Xiaoyuzhou) extract audio transcripts
- **YouTube Shorts**: Treated the same as regular YouTube videos
