# BibiGPT CLI Reference

The `bibi` command is available after installing the BibiGPT desktop app.

## Help Discovery

The CLI supports progressive help — discover subcommands step by step:

```bash
bibi --help                # Global help: list all subcommands
bibi summarize --help      # Summarize-specific options, examples, output format
bibi auth --help           # Auth actions and environment variables
```

Each `--help` includes **examples** — pattern-match off those for fastest results.

## Commands

### Summarize

`bibi summarize` accepts both **URLs** and **local file paths**.

**Important**: URLs containing `?` or `&` must be quoted to avoid shell glob errors.

```bash
# Basic summary (Markdown to stdout, progress to stderr)
bibi summarize "<URL>"

# Local file — audio or video on disk
bibi summarize "/path/to/video.mp4"
bibi summarize "/path/to/podcast.mp3"

# Async mode — recommended for long videos (>30 min)
bibi summarize "<INPUT>" --async

# Chapter-by-chapter summary
bibi summarize "<INPUT>" --chapter

# Subtitles/transcript only (no AI summary)
bibi summarize "<INPUT>" --subtitle

# Full JSON response
bibi summarize "<INPUT>" --json

# Combine flags
bibi summarize "<INPUT>" --chapter --json
bibi summarize "<INPUT>" --subtitle --json
```

Supported local formats: `.mp4`, `.mkv`, `.avi`, `.mov`, `.webm`, `.mp3`, `.wav`, `.m4a`, `.flac`, `.ogg`

### Auth

```bash
bibi auth check         # Check login status
bibi auth login         # OAuth login via browser (saves token automatically)
bibi auth set-token <TOKEN>  # Set API token directly
```

### Updates

```bash
bibi check-update       # Check for new version
bibi self-update        # Download and install latest
```

### Version

```bash
bibi --version          # Print CLI version
```

### Account & Quota

```bash
bibi me                  # Returns account, plan tier, remaining minutes (raw JSON)
bibi me --json           # Same but pretty-printed
```

### Saved Library

```bash
bibi library list                                 # 20 most-recently updated saved videos
bibi library list --limit 50 --json
bibi library list --channelId <authorId>          # filter by channel
bibi library list --cursor "2"                    # next page
bibi library get --id <contentId> --json          # full detail incl. note + chapters + subtitles
bibi library search --keyword "AI agents"         # title/note ILIKE + subtitle full-text
```

### Channel Subscriptions

```bash
bibi channels list --json
bibi channels subscribe --channelUrl "https://www.youtube.com/@..." --json
bibi channels unsubscribe --channelUrl "https://www.youtube.com/@..." --json
bibi channels videos --channelUrl "https://..." --limit 10 --json
```

`subscribe` / `unsubscribe` are mutations (write scope); `list` / `videos` are read-only.

### Feed

```bash
bibi feed --json                          # since last_seen_at (default), up to 20 items
bibi feed --since 2026-05-01 --limit 50   # explicit window
bibi feed --cursor "2026-05-04T12:00:00Z" # paginate via prior nextCursor
bibi feed-mark-seen --json                # bump last_seen_at on all subscribed channels
bibi feed-mark-seen --channelUrl "https://..." --json  # bump just one channel
```

### Collections

```bash
bibi collections list --scope all --json                                     # owned + purchased
bibi collections get --id <collectionId> --json
bibi collections create --name "AI Agents 2026" --isPublic false --json     # write scope
bibi collections add-item --collectionId <id> --contentId <contentId> --json # write scope
bibi collections add-item --collectionId <id> --sourceUrl "https://..." --json
```

### Notes

```bash
bibi notes list --limit 20 --json                       # cursor by updated_at desc
bibi notes list --cursor "2026-05-04T12:00:00Z" --json
bibi notes get --contentId <contentId> --json
bibi notes update --contentId <contentId> --text "..." --json   # write scope
```

### Advanced Tools

```bash
bibi video mindmap --contentId <id> --summary "..." --json          # generate XMind file
bibi video visuals --videoUrl "https://..." --json                  # PPT + OCR + slides task (Pro)
bibi summary by-prompt --contentId <id> --customPrompt "..." --json # re-summarize with custom prompt
bibi notion status --json                                           # check Notion connection
bibi notion export-note --contentId <id> --json                     # push saved note to Notion
bibi collections chat-history --collectionId <id> --json            # cached chat history
```

### Discovery and escape hatch

```bash
bibi --help                                # Static help + cached manifest commands
bibi commands                              # Re-fetch manifest and list all server-defined commands
bibi call <PROCEDURE> [--key value ...]    # Escape hatch — invoke by dotted procedure name
bibi call --help                           # When you need it
```

`bibi --help` reads the local manifest cache; if no commands are listed yet,
run `bibi commands` once after `bibi auth login` to populate it. The CLI
auto-refreshes the manifest every 24 h, so new server-side procedures are
usable without `bibi self-update`.

### Skill installation

```bash
bibi skill                       # Print bundled SKILL.md to stdout
bibi skill mcp-config            # Print MCP client config snippet (JSON)
bibi skill --install             # Install to ~/.claude/skills/bibi/SKILL.md
bibi skill --install --target claude   # Explicit target
```

For the full skill (references + workflows): `npx skills add JimmyLv/bibigpt-skill`.

## Output

| Flag | stdout | stderr |
|------|--------|--------|
| (none) | Markdown summary | Progress messages |
| `--json` | Full JSON response | Progress messages |
| `--subtitle` | Subtitle text | Progress messages |

Pipe-friendly:

```bash
bibi summarize "<URL>" > summary.md
bibi summarize "<URL>" --json | jq '.summary'
bibi summarize "<URL>" --subtitle > transcript.txt
```

## Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Error (auth failure, network error, quota exceeded, etc.) |

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `BIBI_API_TOKEN` | API token (alternative to desktop login) |
