---
name: bibi-library
description: >
  Browse, search, and manage a BibiGPT saved library: already-summarized
  videos, personal notes, and collections. Use when the user asks what they
  already saved, to search past summaries, edit a note, or organize videos
  into a collection. Do not use to summarize a new URL (that is the `bibi`
  skill), follow channels / pull a subscription feed (`bibi-feed`), or
  analyze frames / generate a mind map (`bibi-vision`).
  Triggers: "what have I summarized", "search my library", "my saved videos",
  "my notes", "create a collection", "add to collection", "我之前总结过的",
  "资料库", "搜我的笔记", "合集", "列出最近的总结".
  Same `bibi` CLI binary and same BibiGPT account as the other skills.
agent_created: true
---

# BibiGPT Library — saved videos, notes, collections

This skill is the library half of BibiGPT. **Same CLI (`bibi`), same account**
as `bibi` / `bibi-feed` / `bibi-vision`. It does not summarize a fresh URL.

Landing: https://bibigpt.co/mcp · Install: https://bibigpt.co/agent · Quota: see `references/auth.md`

## When to use / when not

| Use this skill | Use a sibling instead |
|----------------|------------------------|
| List / search / get already-saved videos | New URL → `bibi` (`summarize` / `--subtitle` / `--chapter`) |
| Read or edit notes on saved items | Channel subscribe / "what's new" → `bibi-feed` |
| Collections (list / create / add / chat history) | Frames, slides, mind map → `bibi-vision` |
| Re-summarize a **saved** item with a custom prompt | |

## 1. Detect mode

Run `scripts/bibi-check.sh` if present. Prefer CLI (`command -v bibi`), else `$BIBI_API_TOKEN`, else MCP `https://bibigpt.co/api/mcp`. Details: `references/auth.md`.

## 2. Intent routing

| User intent | Workflow |
|-------------|---------|
| What have I summarized / list saved videos | → `workflows/library-browse.md` |
| Search my library / notes for a keyword | → `workflows/library-browse.md` |
| Read or edit a personal note | → `workflows/notes-manage.md` |
| Collections, playlists, add-to-set | → `workflows/collections-manage.md` |

Bare "summarize this URL" is **not** this skill — hand off to `bibi`.

## 3. Minimum commands (CLI)

```bash
bibi library list --json
bibi library search --keyword "AI agents" --json
bibi library get --id <contentId> --json
bibi notes list --limit 20 --json
bibi collections list --scope all --json
```

Full flags: `references/cli.md`. MCP names: `list_saved_videos`, `search_saved_videos`, `get_saved_video`, `list_notes`, `get_note`, `update_note`, `list_collections`, `get_collection`, `create_collection`, `add_to_collection`, `generate_summary_by_prompt`, `get_collection_chat_history`.
