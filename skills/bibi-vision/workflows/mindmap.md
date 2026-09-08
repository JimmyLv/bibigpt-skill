# Workflow: Mind map from a saved summary

Use when the user wants an XMind mind map of a video they already saved.

## Triggers

"mind map", "思维导图", "xmind", "make a map of this summary"

## Steps

Need a `contentId`. If the user only has a URL, summarize first with the `bibi` skill, then list/get via `bibi-library` if the id is unknown.

```bash
bibi video mindmap \
  --contentId <contentId> \
  --summary "$(bibi notes get --contentId <contentId> --json | jq -r .note)" \
  --json
```

MCP: `generate_video_mindmap`. Cached per `(user, contentId)`. Response includes `fileUrl` for the `.xmind` file.

Do not generate talking-head video, digital humans, or shaders.
