# Workflow: User Notes (Personalized Summaries)

Use when the user wants to read, edit, or list their personal notes on saved videos. In BibiGPT, the "note" is the user's saved version of a video summary — initially the AI-generated summary, but the user can edit it afterwards (and Notion/Obsidian sync may push edits back).

## Triggers

- "Show me my notes on <video>"
- "Update the note for <video>"
- "List my recent notes"
- "我的笔记"
- "把这个视频的笔记改成 ..."
- "Save this as my note for the video"

## Steps

### 1. List notes (paginated)

```bash
bibi notes list --limit 20 --json                       # default
bibi notes list --limit 50 --json
bibi notes list --cursor "2026-05-04T12:00:00Z" --json  # paginate
```

Returns `{ notes: [{ contentId, title, sourceUrl, excerpt, updatedAt }], nextCursor }`.

`excerpt` is the first 200 characters of the note. For full text, call `notes.get`.

### 2. Get a single note

```bash
bibi notes get --contentId <contentId> --json
# → { "contentId":..., "note":..., "updatedAt":... }
```

If the user has never saved a note for that contentId, `note` is `null` (valid state).

### 3. Update a note

```bash
bibi notes update --contentId <contentId> --text "My polished summary..." --json
# → { "success": true }
```

Mutation; requires write scope. Empty string is rejected (won't clobber existing note). Updating triggers any user-configured global webhook (Notion, etc.).

## Output formatting

For lists: render a Markdown list with title (linked to sourceUrl) + relative-time updatedAt + excerpt. For single note: render the full text as Markdown.

## Common follow-ups

- "Edit this note to focus on X" → fetch with `notes.get`, agent rewrites, then `notes.update`
- "Find videos where I noted Y" → use `library.search --keyword Y` (which searches notes by ILIKE)
- "Export note to Notion" → call `bibi notion export-note --contentId <id>` (the user's configured global webhook still fires on `notes.update` automatically)

## Notes

- `notes.update` is a **mutation** (write scope); `list` and `get` are read-only.
- `notes.list` uses cursor by `updated_at desc` — pass `nextCursor` from prior response to continue.
- Unsaved videos (no `user_contents_note` row) won't appear in `notes.list` even if they're in `library.list`.
