# Transcript Extract

Get raw subtitles or transcript with timestamps, optionally with speaker identification.

## Triggers

"get subtitles", "extract transcript", "download captions", "获取字幕", "提取文字稿", "get the raw text"

## Steps

### 1. Environment Check

Run `scripts/bibi-check.sh` to detect available mode.

### 2. Ask Preferences (optional)

If the user doesn't specify, use defaults. Otherwise ask:
- **Language**: default is the original audio language. Pass `audioLanguage` to override
- **Speaker identification**: enable with `enabledSpeaker=true` for multi-speaker content (interviews, panels)

### 3. Fetch Subtitles

**CLI mode:**
```bash
bibi summarize "<URL>" --subtitle
```

For JSON with timestamps:
```bash
bibi summarize "<URL>" --subtitle --json
```

**API mode:**
```bash
ENCODED=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$URL")
curl -s "https://api.bibigpt.co/api/v1/getSubtitle?url=$ENCODED" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

Optional params: `&audioLanguage=en`, `&enabledSpeaker=true`

See `references/api.md` endpoint #4 for full details.

### 4. Format Output

Offer the user their preferred format:

**Plain text** (readable):
```
[Speaker A]: The key insight here is that...
[Speaker B]: I agree, and additionally...
```

**Timestamped** (for reference):
```
[00:00:15] The key insight here is that...
[00:00:32] I agree, and additionally...
```

**File output**:
```bash
# Save as text file
bibi summarize "<URL>" --subtitle > transcript.txt
```

### 5. Follow-up Options

- "Now summarize this" → `workflows/quick-summary.md`
- "Polish into a readable article" → `workflows/article-rewrite.md`
- "Break down by chapter" → `workflows/deep-dive.md`
- "Save to my notes" → `workflows/export-notes.md`
