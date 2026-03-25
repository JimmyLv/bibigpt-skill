# Quick Summary

Summarize a single video or audio URL to get an AI-generated overview.

## Triggers

"summarize this video", "what's this about", "TL;DR", "总结这个视频", "帮我看看这个视频讲了什么", "video summary", "podcast notes"

## Steps

### 1. Environment Check

Run `scripts/bibi-check.sh` to detect available mode (CLI or API).
If neither mode is available, follow the setup instructions in `references/installation.md`.

### 2. Validate Input

- Extract the URL **or local file path** from the user's message
- If it's a URL: confirm it looks like a supported platform (see `references/supported-platforms.md`)
- If it's a local file path: confirm the file exists and is a supported format (`.mp4`, `.mp3`, `.wav`, `.mkv`, `.mov`, `.webm`, `.m4a`, `.flac`, `.ogg`, `.avi`)
- If no URL or file is provided, ask the user to paste one
- If the URL looks shortened (b23.tv, xhslink.com), it will be auto-expanded

### 3. Estimate Duration

- If the user mentions "long video", "1-hour lecture", etc., recommend async mode
- If unsure, proceed synchronously — the API will return an error if the video is too long for sync processing

### 4. Execute Summary

**CLI mode** (supports both URLs and local files):
```bash
bibi summarize "<URL_OR_FILE_PATH>"
```

For long videos (>30 min):
```bash
bibi summarize "<URL_OR_FILE_PATH>" --async
```

**API mode** (URLs only — no direct file upload):
```bash
ENCODED=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$URL")
curl -s "https://api.bibigpt.co/api/v1/summarize?url=$ENCODED" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

**API mode with local file**: The API does not accept file uploads directly. Guide the user to:
1. Upload the file to a publicly accessible URL (OSS, S3, Cloudflare R2, etc.)
2. Pass the public URL to the API

For long videos, use async:
```bash
# Create task
TASK=$(curl -s "https://api.bibigpt.co/api/v1/createSummaryTask?url=$ENCODED" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli")
TASK_ID=$(echo "$TASK" | jq -r '.taskId')

# Poll every 3s until completed
while true; do
  STATUS=$(curl -s "https://api.bibigpt.co/api/v1/getSummaryTaskStatus?taskId=$TASK_ID" \
    -H "Authorization: Bearer $BIBI_API_TOKEN" \
    -H "x-client-type: bibi-cli")
  echo "$STATUS" | jq -r '.status'
  [ "$(echo "$STATUS" | jq -r '.status')" = "completed" ] && break
  sleep 3
done
```

See `references/cli.md` and `references/api.md` for full command/endpoint details.

### 5. Format Output

Present the result to the user:
- **Title**: Video/audio title
- **Source**: Platform name + original URL
- **Summary**: The AI-generated Markdown summary
- **Duration/Quota**: Mention `costDuration` and `remainingTime` if relevant

### 6. Follow-up Options

After presenting the summary, offer:
- "Want a chapter-by-chapter breakdown?" → `workflows/deep-dive.md`
- "Need the raw transcript?" → `workflows/transcript-extract.md`
- "Turn this into an article?" → `workflows/article-rewrite.md`
- "Save to Notion or Obsidian?" → `workflows/export-notes.md`
