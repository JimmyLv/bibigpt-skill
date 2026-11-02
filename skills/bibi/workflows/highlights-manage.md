# Workflow: Highlights

Use when the user wants to read, add, annotate or delete highlights on videos already in their BibiGPT library, or wants the "best moments" of a saved video.

## Triggers

- "Show my highlights" / "我划过线的视频"
- "What did I highlight in <video>"
- "Highlight the part where they talk about X" / "把讲 X 的那段划出来"
- "Add a comment to this highlight" / "给这条划线加个批注"
- "Delete these highlights" / "清空这个视频的划线"
- "Find the best moments / clips of this video" / "高光时刻" / "爆款切片"

## Steps

### 1. Videos with highlights

```bash
bibi highlights videos --json                       # manual highlights, newest first
bibi highlights videos --source topics --json       # videos with AI highlight topics
# → { videos: [{ contentId, title, sourceUrl, count, lastUpdatedAt }] }
```

`contentId` is `null` when the video is not in the user's library (a shared page); you can't read its highlights with the commands below.

### 2. Read one video's highlights

```bash
bibi highlights get --contentId <contentId> --json
# → { highlights: [{ scope, sectionId, highlightId, text, comment, timestampSeconds, createdAt }],
#     topics: [{ title, summary, segments: [{ start, end, summary }] }] }
```

`topics` are AI highlight topics already generated on the web; this command never generates new ones.

### 3. Highlight a moment

```bash
bibi highlights add --contentId <contentId> --timestamp 754 --text "the quote" --comment "why it matters" --json
```

Highlights are added by time (seconds). Get timestamps from the transcript (`bibi summarize <URL> --subtitle --json`, MCP `get_subtitle`). Adding the same second again updates that highlight. Text-range highlights inside the summary are made in the web app.

### 4. Edit a comment

```bash
bibi highlights set-comment --contentId <id> --scope <scope> --sectionId <sectionId> --highlightId <highlightId> --comment "..." --json
```

Use the `scope` / `sectionId` / `highlightId` from `highlights get`. `--comment null` clears it.

### 5. Delete highlights

```bash
bibi highlights remove --contentId <id> --highlights '[{"scope":"...","sectionId":"...","highlightId":"..."}]' --json
bibi highlights remove --contentId <id> --all true --json     # clear every highlight on the video
```

Pass exactly one of `--highlights` (a JSON array) or `--all true`. Deletes cannot be undone: list what will go and wait for the user's yes.

## Best moments and clips — do it yourself

The web app has credit-spending buttons for AI highlight topics and viral clips. Agents get the same result from the transcript:

1. Read the transcript with timestamps (`get_subtitle`, or `library get` for a saved video).
2. Pick the moments that answer the user's ask (topics, quotable lines, clip-worthy 15–60 s spans) and show them with start / end times.
3. If the user wants them kept, save each with `highlights add` (put the span and reason in `--comment`).

## Error handling

- **404 NOT_FOUND**: the contentId is not in the user's library — find it with `library search` first.
- **400 BAD_REQUEST** on `remove`: pass `--highlights` or `--all true`, not both or neither.

## Notes

- `add`, `set-comment`, `remove` are **mutations** (write scope).
- Deleting a saved video (`bibi library remove --contentId <id>`) also deletes its highlights and note. Confirm first.
