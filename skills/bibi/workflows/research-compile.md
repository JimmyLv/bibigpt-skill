# Research & Compile

Summarize multiple videos on the same topic and synthesize insights into a research brief.

## Triggers

"research this topic", "compare these videos", "what do these say about...", "综合分析", "对比总结", "cross-reference these sources"

## Steps

### 1. Environment Check

Run `scripts/bibi-check.sh` to detect available mode.

### 2. Gather Sources

**If the user provides URLs**: use them directly.

**If the user provides a topic**: ask for specific URLs to analyze. BibiGPT summarizes content from URLs — it does not search for videos. Example prompt:

> "I can summarize specific videos for you. Could you share the URLs of the videos you'd like me to analyze on this topic?"

### 3. Summarize Each Source

For each URL, run the quick-summary workflow:

**CLI mode:**
```bash
bibi summarize "<URL>" --json
```

**API mode:**
```bash
ENCODED=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$URL")
curl -s "https://api.bibigpt.co/api/v1/summarize?url=$ENCODED&includeDetail=true" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

Collect all summaries before proceeding to synthesis.

### 4. Synthesize

Analyze all summaries together to identify:
- **Common themes**: Points made across multiple sources
- **Unique insights**: Ideas found in only one source
- **Divergent views**: Where sources disagree or offer different perspectives
- **Key quotes**: Notable statements with source attribution

### 5. Present Research Brief

```markdown
# Research Brief: [Topic]

## Sources Analyzed
1. **[Title 1]** ([platform]) — [one-line key takeaway]
2. **[Title 2]** ([platform]) — [one-line key takeaway]
3. **[Title 3]** ([platform]) — [one-line key takeaway]

## Common Themes
- [Theme 1]: discussed in sources 1, 2, 3
- [Theme 2]: discussed in sources 1, 3

## Unique Insights
- Source 1 uniquely argues that...
- Source 3 introduces the concept of...

## Divergent Views
- On [topic X], Source 1 claims... while Source 2 argues...

## Key Quotes
> "[Quote]" — Source 1, [timestamp]
> "[Quote]" — Source 2, [timestamp]
```

### 6. Follow-up Options

- "Turn this into an article" → `workflows/article-rewrite.md`
- "Save to Obsidian" → `workflows/export-notes.md`
- "Get the full transcript of source #N" → `workflows/transcript-extract.md`
- "Add more sources to this research" — repeat steps 2-5 with additional URLs
