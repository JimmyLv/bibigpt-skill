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

## Local Files

### CLI Mode (Recommended)

The `bibi` CLI directly accepts local file paths — no upload needed:

```bash
bibi summarize "/path/to/video.mp4"
bibi summarize "/path/to/podcast.mp3" --chapter
```

Supported formats:
- Audio: `.mp3`, `.wav`, `.m4a`, `.flac`, `.ogg`
- Video: `.mp4`, `.mkv`, `.avi`, `.mov`, `.webm`

### API Mode (No Direct File Upload)

The OpenAPI endpoints only accept URLs, not local files. To summarize a local file via API:

1. Upload the file to any publicly accessible storage (e.g., OSS, S3, Cloudflare R2, or any file hosting)
2. Get the public URL
3. Pass the public URL to the API:

```bash
curl -s "https://api.bibigpt.co/api/v1/summarize?url=ENCODED_PUBLIC_URL" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

If the user has a local file and no CLI installed, guide them to:
- Upload to a cloud storage service first
- Or install the BibiGPT desktop app to use CLI mode directly

## Platform-Specific Notes

- **Bilibili**: Short links (`b23.tv/xxx`) are auto-expanded. Use `expandUrl` API if you need the full URL first
- **Twitter/X**: Only video tweets are supported; text-only tweets return an error
- **Xiaohongshu**: Short links (`xhslink.com/xxx`) are auto-expanded
- **Podcasts**: All three podcast platforms (Apple, Spotify, Xiaoyuzhou) extract audio transcripts
- **YouTube Shorts**: Treated the same as regular YouTube videos
