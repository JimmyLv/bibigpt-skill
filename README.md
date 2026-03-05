# bibigpt-skill

Claude Code skill for summarizing videos, audio, and podcasts via the [BibiGPT](https://bibigpt.co) CLI (`bibi`).

## Install

```bash
npx skills add JimmyLv/bibigpt-skill
```

## Prerequisites

Install the BibiGPT Desktop app:

- **macOS**: `brew install --cask jimmylv/bibigpt/bibigpt`
- **Windows**: Download from [bibigpt.co/download/desktop](https://bibigpt.co/download/desktop)

Then log in via the desktop app. The CLI reads your session automatically.

## Usage

Once the skill is installed, ask Claude Code to summarize any video or audio URL:

```
> Summarize this video: https://www.youtube.com/watch?v=xxxxx
```

The skill will call `bibi summarize <URL>` and return the result.

## Commands

| Command | Description |
|---------|-------------|
| `bibi summarize "<URL>"` | Summarize a video/audio URL |
| `bibi summarize "<URL>" --async` | Async mode (long videos) |
| `bibi summarize "<URL>" --chapter` | Chapter-by-chapter summary |
| `bibi summarize "<URL>" --subtitle` | Fetch subtitles/transcript only |
| `bibi summarize "<URL>" --json` | Full JSON output |
| `bibi auth check` | Check auth status |
| `bibi auth login` | Open browser to log in |

## License

MIT
