# Visual Analysis

Analyze video frames to understand visual content beyond the audio transcript — slides, demos, diagrams, on-screen text.

## Triggers

"analyze what's shown", "visual content", "画面分析", "screenshot analysis", "what's on screen", "analyze the slides", "视觉分析"

## Steps

### 1. Environment Check

Run `scripts/bibi-check.sh` to detect available mode.

### 2. Explain Capability & Limitations

BibiGPT can analyze video frames for visual content. Be upfront about current limitations:

- **Best for**: Slides, presentations, tutorials, demos, whiteboard sessions
- **Current access**: Visual analysis is primarily available through the BibiGPT web UI
- **CLI/API limitation**: Frame-by-frame visual analysis is not yet exposed via CLI or the public OpenAPI. The web UI at `https://bibigpt.co/video/[id]` provides this feature

### 3. Get Text Summary First

Before visual analysis, get the text-based summary for context:

**CLI mode:**
```bash
bibi summarize "<URL>" --chapter
```

**API mode:**
```bash
ENCODED=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$URL")
curl -s "https://api.bibigpt.co/api/v1/summarizeByChapter?url=$ENCODED&includeDetail=true" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

This provides the audio/text content and chapter structure as a foundation.

### 4. Direct to Web UI for Visual Analysis

1. Use the `htmlUrl` from the summary response (e.g., `https://bibigpt.co/video/xxx`)
2. Inform the user:

> "The text summary is above. For visual frame analysis (slides, diagrams, on-screen content), visit the BibiGPT web interface:
> [htmlUrl]
>
> The web UI can analyze key frames and extract visual information that complements the audio transcript."

### 5. Present Combined Results

If the user has both text and visual results, combine them:

```markdown
# [Video Title] — Combined Analysis

## Audio/Text Summary
[Chapter-by-chapter text summary]

## Visual Content Highlights
[Visual analysis from web UI — slides, diagrams, key frames]

## Insights
- Points where visual content adds information not in the audio
- Key slides or diagrams that support the spoken content
```

### 6. Follow-up Options

- "Get the full transcript" → `workflows/transcript-extract.md`
- "Turn this into an article" → `workflows/article-rewrite.md`
- "Just give me the summary" → `workflows/quick-summary.md`
- "Save these notes" → `workflows/export-notes.md`
