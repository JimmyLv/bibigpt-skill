# bibigpt-skill

Claude Code / OpenClaw / Codex AI Agent skill for summarizing videos, audio, and podcasts via the [BibiGPT](https://bibigpt.co) CLI (`bibi`).

## Install

### Claude Code

```bash
npx skills add JimmyLv/bibigpt-skill
```

### OpenClaw

OpenClaw also supports this skill! Install with:

```bash
npx skills add JimmyLv/bibigpt-skill --agents OpenClaw --yes
```

Or interactively:

```bash
npx skills add JimmyLv/bibigpt-skill
# Select "OpenClaw" when prompted
```

After installation, askClaw to summarize Open videos or check auth status just like with Claude Code.

## Prerequisites

Install the BibiGPT Desktop app:

- **macOS**: `brew install --cask jimmylv/bibigpt/bibigpt` ([Homebrew tap](https://github.com/JimmyLv/homebrew-bibigpt))
- **Windows**: `winget install BibiGPT --source winget` or download from [bibigpt.co/download/desktop](https://bibigpt.co/download/desktop)

Then log in via the desktop app. The CLI reads your session automatically.

## Usage

### Claude Code

Once the skill is installed, ask Claude Code to summarize any video or audio URL:

```
> Summarize this video: https://www.youtube.com/watch?v=xxxxx
```

The skill will call `bibi summarize <URL>` and return the result.

### OpenClaw

Same experience! Just askClaw in your favorite channel (Feishu, Discord, Telegram, etc.):

```
@Claw 帮我总结这个视频 https://www.youtube.com/watch?v=xxxxx
```

Or check your BibiGPT auth status:

```
@Claw 检查一下 bibi 登录状态
```

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
| `bibi check-update` | Check for new version |
| `bibi self-update` | Download and install latest version |

## License

MIT
