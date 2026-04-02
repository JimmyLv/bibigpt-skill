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
