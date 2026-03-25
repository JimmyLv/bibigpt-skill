# Batch Process

Process multiple URLs sequentially. Ideal for content teams, researchers, or API users.

## Triggers

"summarize all these", "batch", "process these URLs", "批量总结", "summarize these videos", "process multiple links"

## Steps

### 1. Environment Check

Run `scripts/bibi-check.sh` to detect available mode.
Async mode is recommended for batch processing to avoid timeouts.

### 2. Collect URLs

- Parse the user's message for multiple URLs
- Present the list back and confirm:

```
Found N URLs to process:
1. [URL 1] (YouTube)
2. [URL 2] (Bilibili)
3. [URL 3] (Podcast)

Proceed with batch summarization?
```

- If any URL looks unsupported, flag it (see `references/supported-platforms.md`)

### 3. Estimate Cost

- Each URL costs duration-based quota (minutes of content)
- Warn the user about total estimated quota usage
- If quota is limited, suggest processing in priority order

### 4. Process Loop

For each URL, execute in sequence:

**CLI mode:**
```bash
for URL in "${URLS[@]}"; do
  echo "Processing: $URL"
  bibi summarize "$URL" --json
  echo "---"
done
```

**API mode** (prefer async for batch):
```bash
# Step 1: Create all tasks
for URL in "${URLS[@]}"; do
  ENCODED=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$URL")
  curl -s "https://api.bibigpt.co/api/v1/createSummaryTask?url=$ENCODED" \
    -H "Authorization: Bearer $BIBI_API_TOKEN" \
    -H "x-client-type: bibi-cli"
done

# Step 2: Poll each task until all complete
```

Report progress after each URL completes:
```
[1/5] ✓ "Video Title" — 12 min summary
[2/5] Processing...
```

### 5. Compile Results

Present all summaries in a structured format:

```markdown
# Batch Summary (N videos)

## 1. [Video Title]
**Source**: [platform] | **Duration**: [X min]
[Summary]

## 2. [Video Title]
**Source**: [platform] | **Duration**: [X min]
[Summary]

...

**Total quota used**: X minutes | **Remaining**: Y minutes
```

### 6. Follow-up Options

- "Save all to Notion" → `workflows/export-notes.md`
- "Compare these videos" → `workflows/research-compile.md`
- "Get detailed chapters for video #N" → `workflows/deep-dive.md`
- "Turn video #N into an article" → `workflows/article-rewrite.md`
