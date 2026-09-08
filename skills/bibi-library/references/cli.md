# bibi-library CLI

Same binary as the `bibi` skill. Discover the rest with `bibi --help`. Always pass `--json` when an agent will parse stdout.

```bash
bibi library list --json
bibi library list --limit 50 --json
bibi library list --channelId <authorId> --json
bibi library list --cursor "2" --json
bibi library get --id <contentId> --json
bibi library search --keyword "AI agents" --json

bibi notes list --limit 20 --json
bibi notes get --contentId <contentId> --json
bibi notes update --contentId <contentId> --text "..." --json

bibi collections list --scope all --json
bibi collections get --id <collectionId> --json
bibi collections create --name "AI Agents 2026" --isPublic false --json
bibi collections add-item --collectionId <id> --contentId <contentId> --json
bibi collections chat-history --collectionId <id> --json

bibi summary by-prompt --contentId <id> --customPrompt "..." --json
```

MCP tools: `list_saved_videos`, `get_saved_video`, `search_saved_videos`, `list_notes`, `get_note`, `update_note`, `generate_summary_by_prompt`, `list_collections`, `get_collection`, `create_collection`, `add_to_collection`, `get_collection_chat_history`.
