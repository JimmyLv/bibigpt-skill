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
bibi collections folders --json
bibi collections create --name "Agents" --parentId <folderId> --json
bibi collections move --collectionId <id> --newParentId null --json   # null = top level
bibi collections update --collectionId <id> --name "..." --json
bibi collections move-items --sourceCollectionId <a> --targetCollectionId <b> --contentIds '["id1"]' --json
bibi collections remove-items --collectionId <id> --contentIds '["id1"]' --json
bibi collections for-content --contentId <contentId> --json
bibi library remove --contentId <contentId> --json            # deletes video + note + highlights
bibi collections remove --collectionId <id> --json             # sub-folders go too
bibi collections update-summary --collectionId <id> --summary "..." --json
bibi highlights videos --json
bibi highlights get --contentId <contentId> --json
bibi highlights add --contentId <contentId> --timestamp 754 --comment "..." --json
bibi highlights set-comment --contentId <id> --scope <s> --sectionId <sec> --highlightId <h> --comment "..." --json
bibi highlights remove --contentId <id> --all true --json

bibi summary by-prompt --contentId <id> --customPrompt "..." --json
```

MCP tools: `list_saved_videos`, `get_saved_video`, `search_saved_videos`, `list_notes`, `get_note`, `update_note`, `generate_summary_by_prompt`, `list_collections`, `get_collection`, `create_collection`, `add_to_collection`, `get_collection_chat_history`, `list_collection_folders`, `move_collection`, `update_collection`, `move_collection_items`, `remove_from_collection`, `get_video_collections`, `delete_collection`, `update_collection_summary`, `delete_saved_video`, `list_highlighted_videos`, `get_video_highlights`, `add_highlight`, `set_highlight_comment`, `delete_highlights`.
