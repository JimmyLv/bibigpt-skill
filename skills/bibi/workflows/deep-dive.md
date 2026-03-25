# Deep Dive

Get a chapter-by-chapter summary with timestamps, then optionally ask follow-up questions about specific sections.

## Triggers

"chapter summary", "break down by section", "detailed summary", "分章节总结", "逐章总结", "what topics does this cover"

## Steps

### 1. Environment Check

Run `scripts/bibi-check.sh` to detect available mode.

### 2. Get Chapter Summary

**CLI mode:**
```bash
bibi summarize "<URL>" --chapter
```

**API mode:**
```bash
ENCODED=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$URL")
curl -s "https://api.bibigpt.co/api/v1/summarizeByChapter?url=$ENCODED" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

Optional: add `&outputLanguage=en-US` (or other language code) for translated output.

See `references/api.md` endpoint #3 for full details.

### 3. Present Results

Format each chapter as:

```
## Chapter 1: [Title] (00:00 – 05:30)
[Chapter summary]

## Chapter 2: [Title] (05:30 – 12:15)
[Chapter summary]
...
```

If `chapters` array is empty, fall back to the overall `chapterSummary` text and explain that the video did not have chapter markers.

### 4. Interactive Q&A

If the user wants to go deeper into a specific chapter:

1. Use the returned subtitle data (from `includeDetail=true`) as context
2. Answer follow-up questions about specific sections
3. Reference timestamps when quoting content

For example:
- "What exactly did they say about X in chapter 3?"
- "Can you elaborate on the point at 15:30?"

### 5. Follow-up Options

- "Get the full transcript" → `workflows/transcript-extract.md`
- "Turn a specific chapter into an article" → `workflows/article-rewrite.md`
- "Compare with another video on the same topic" → `workflows/research-compile.md`
- "Save these notes" → `workflows/export-notes.md`
