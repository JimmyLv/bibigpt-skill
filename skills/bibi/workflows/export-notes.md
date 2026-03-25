# Export Notes

Save summaries, transcripts, or articles to external tools or local files.

## Triggers

"save to Notion", "export to Obsidian", "save notes", "导出笔记", "save this summary", "download as markdown", "copy to clipboard"

## Steps

### 1. Determine Content to Export

- If there is already a summary/transcript/article from this session → use it
- If not → ask the user what they'd like to export and run the appropriate workflow first:
  - Summary → `workflows/quick-summary.md`
  - Chapters → `workflows/deep-dive.md`
  - Transcript → `workflows/transcript-extract.md`
  - Article → `workflows/article-rewrite.md`

### 2. Choose Destination

Ask the user where to save:

| Destination | Method |
|-------------|--------|
| **Local Markdown file** | Write to filesystem |
| **Obsidian vault** | Write `.md` to vault path |
| **Clipboard** | Copy content |
| **Notion** | Redirect to web UI |

### 3A. Local Markdown / Obsidian

Format the content as a proper Markdown file with YAML frontmatter:

```markdown
---
title: "[Video Title]"
source: "[Original URL]"
platform: "[youtube/bilibili/podcast/...]"
date: "[YYYY-MM-DD]"
duration: "[X min]"
tags: [video-summary]
---

# [Video Title]

[Summary / Transcript / Article content]

---
*Summarized by [BibiGPT](https://bibigpt.co)*
```

Write to the specified path:
```bash
# Default location
cat > "$HOME/Documents/bibigpt-notes/[slug].md" << 'EOF'
[content]
EOF
```

For **Obsidian**, ask for the vault path or use a common default:
```bash
# Common Obsidian vault paths
$HOME/Documents/Obsidian/[vault-name]/BibiGPT/[slug].md
```

### 3B. Clipboard

```bash
# macOS
echo "[content]" | pbcopy

# Linux
echo "[content]" | xclip -selection clipboard
```

### 3C. Notion

BibiGPT's Notion integration is available through the web UI:

1. The summary response includes `htmlUrl` (e.g., `https://bibigpt.co/video/xxx`)
2. Direct the user to visit the `htmlUrl` and use the "Save to Notion" button
3. First-time users need to connect their Notion workspace at https://bibigpt.co/settings

### 4. Confirm Success

Report what was saved and where:

```
Saved to: ~/Documents/bibigpt-notes/video-title-2024-01-15.md
Content: Summary + Chapter breakdown
Size: 2.3 KB
```

### 5. Follow-up Options

- "Summarize another video" → `workflows/quick-summary.md`
- "Export in a different format" — re-run with different destination
