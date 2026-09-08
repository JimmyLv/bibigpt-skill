# bibi-vision CLI

Same binary as the `bibi` skill. Discover the rest with `bibi --help`. Always pass `--json` when an agent will parse stdout.

```bash
bibi video visuals --videoUrl "https://..." --json
bibi video mindmap --contentId <id> --summary "..." --json
```

`bibi video visuals` is Pro-only and rate-limited. It returns a `taskId`; poll until the task completes. Best for slides, presentations, tutorials, demos, on-screen text — not for inventing digital humans, lip-sync, or shaders (BibiGPT does not expose those).

MCP tools: `extract_video_visuals`, `generate_video_mindmap`.

Need a transcript or chapter summary first? That is the `bibi` skill (`summarize_*` / `get_subtitle`), not this one.
