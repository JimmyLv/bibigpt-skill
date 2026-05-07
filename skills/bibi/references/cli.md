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
bibi call me                  # Returns account, plan tier, remaining minutes (raw JSON)
bibi call me --json           # Same but pretty-printed
```

### Saved Library (Phase 2)

```bash
bibi call library.list                                 # 20 most-recently updated saved videos
bibi call library.list --limit 50 --json
bibi call library.list --channelId <authorId>          # filter by channel
bibi call library.list --cursor "2"                    # next page
bibi call library.get --id <contentId> --json          # full detail incl. note
bibi call library.search --keyword "AI agents"         # ILIKE on title + note (MVP)
```

### Channel Subscriptions (Phase 2)

```bash
bibi call channels.list --json
bibi call channels.subscribe --channelUrl "https://www.youtube.com/@..." --json
bibi call channels.unsubscribe --channelUrl "https://www.youtube.com/@..." --json
bibi call channels.videos --channelUrl "https://..." --limit 10 --json
```

### Feed (Phase 2)

```bash
bibi call feed --json                          # last 7 days, up to 20 items
bibi call feed --since 2026-05-01 --limit 50   # explicit window
bibi call feed --cursor "2026-05-04T12:00:00Z" # paginate via prior nextCursor
```

### Collections (Phase 2)

```bash
bibi call collections.list --scope all --json                                     # owned + purchased
bibi call collections.get --id <collectionId> --json
bibi call collections.create --name "AI Agents 2026" --isPublic false --json     # write scope
bibi call collections.add-item --collectionId <id> --contentId <contentId> --json # write scope
bibi call collections.add-item --collectionId <id> --sourceUrl "https://..." --json
```

### Notes (Phase 2)

```bash
bibi call notes.list --limit 20 --json                       # cursor by updated_at desc
bibi call notes.list --cursor "2026-05-04T12:00:00Z" --json
bibi call notes.get --contentId <contentId> --json
bibi call notes.update --contentId <contentId> --text "..." --json   # write scope
```

`subscribe`/`unsubscribe` are mutations (write scope); `list`/`videos` are read-only.

### Generic dispatch (manifest-driven)

```bash
bibi commands                              # List all server-defined CLI commands
bibi call <PROCEDURE> [--key value ...]    # Invoke any procedure by dotted name
bibi call --help                           # Detailed dispatcher help
```

The CLI fetches `/api/cli-manifest.json` and caches it 24h, so new server-side
procedures are usable without `bibi self-update`.

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
