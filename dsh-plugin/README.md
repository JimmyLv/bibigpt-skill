# @bibigpt/dsh-plugin

Give [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) the ability to watch videos.

Installing this bundle registers the `bibi` skill, so the agent can summarize YouTube, Bilibili, podcasts, TikTok, Twitter/X and Xiaohongshu links — or any local audio/video file — and pull out transcripts, chapter summaries and notes.

## Install

```bash
dsh plugin --profile web add "github:JimmyLv/bibigpt-skill#path:/dsh-plugin"
```

Use `--profile tui` or `--profile headless` to install it into those profiles instead. Restart the profile afterwards; `/bibi` then appears under **Skills** in the command palette.

No npm publish is involved — `dsh plugin` forwards to pnpm, which can install a package straight from a subdirectory of a git repository. The `prepare` script pulls the skill bundle in during that install.

## Verify

```bash
dsh --profile web --dump-config | grep -A1 bibigpt
```

The bundle contributes one row:

```yaml
- id: bibigpt
  name: '@bibigpt/dsh-plugin'
```

## Remove

```bash
dsh plugin --profile web remove @bibigpt/dsh-plugin
```

## What the skill needs at runtime

The skill drives BibiGPT through either the `bibi` CLI (macOS/Windows) or the OpenAPI endpoint (any platform). Both need a BibiGPT account — the skill body walks the agent through the setup and tells it what to say when a call comes back unpaid. See [`references/installation.md`](../skills/bibi/references/installation.md).

## Without the plugin

DeepSeek Harness also discovers skills from disk. Copying the bundle into any of its skill roots works just as well:

```bash
cp -R skills/bibi ~/.agents/skills/bibi
```

`~/.agents/skills` is shared with other SKILL.md-aware agents, so one copy serves both DeepSeek Harness and Claude Code. The plugin exists to make installing and updating a single command.

## Layout

| Path | Role |
|---|---|
| `index.js` | Registers the packaged skill through `ctx.skills.register()` |
| `cordis.patch.yml` | The layer this bundle contributes to a profile |
| `skills/bibi/` | Build artifact — synced from `../skills/bibi` on `prepack` |

`../skills/bibi` is the single source of truth. Edit it there, never here.

## Develop

```bash
npm run sync-skill   # copy ../skills/bibi in
node --test          # unit tests
```

Install a working copy into a profile without publishing:

```bash
dsh plugin --profile web add /absolute/path/to/bibigpt-skill/dsh-plugin
```

## License

MIT
