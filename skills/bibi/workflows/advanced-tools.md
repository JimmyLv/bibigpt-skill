# Workflow: Advanced Tools (Mindmap / Visuals / By-Prompt / Notion / Chat)

Bridges high-value but lower-frequency capabilities. Most are MVP-staged — schemas and routing exist, full implementation lands in later sub-phases. The procedures emit **clear NOT_IMPLEMENTED messages** with the exact fallback when not yet ready, so the agent can degrade gracefully.

## Triggers and routing

| Intent | Status | Notes |
|---|---|---|
| "Make a mindmap from this summary" | ✅ Working — `bibi call video.mindmap --contentId <id> --summary "..."` | Returns `.xmind` file URL; cached per (user, contentId) |
| "Analyze the visuals / slides / on-screen text" | ✅ Working — `bibi call video.visuals --videoUrl "https://..."` | Pro-only; rate-limited; returns taskId — poll `vision.getVideoProcessingTask` for completion |
| "Re-summarize with my own prompt" | ✅ Working — `bibi call summary.byPrompt --contentId <id> --customPrompt "..."` | Always regenerates (customPrompt is uncacheable in MVP); overwrites the user's saved note |
| "Push this video summary to Notion" | ✅ Working — `bibi call notion.exportNote --contentId <id>` | Requires prior Notion OAuth (check via `notion.status`); creates a new page in the bound database |
| "Show me the chat history for collection X" | ✅ Working — `bibi call collections.chatHistory --collectionId <id>` | Returns prior messages + AI-suggested questions |

## Steps — what works today

### 1. Notion connection status

```bash
bibi call notion.status --json
# → { "connected": true, "workspaceId":..., "workspaceName":..., "email":... }
```

If `connected` is `false`, surface this guide to the user:
> Notion 还没连接。请到 https://bibigpt.co/user/integration → Notion 完成 OAuth 授权。

### 2. Collection chat history

```bash
bibi call collections.chatHistory --collectionId <id> --json
# → { "messages": [...], "suggestedQuestions": [...], "updatedAt": "..." }
```

Returns prior chat messages and AI-suggested questions. Use this to summarize what the user has already discussed about a collection before generating new questions or extending the conversation.

### 3. Notion export pre-flight

```bash
bibi call notion.exportNote --contentId <id> --json
```

The agent endpoint **validates** that the note exists and Notion is connected, then returns NOT_IMPLEMENTED with a fallback hint. Use for "can I push this to Notion?" checks before doing the actual push via the legacy `notion.sendToNotion` tRPC procedure.

## Working examples (all fully functional)

### Mindmap

```bash
bibi call video.mindmap --contentId <contentId> --summary "$(bibi call notes.get --contentId <contentId> --json | jq -r .note)" --json
# → { "fileUrl": "https://...storage.../<userId>/<contentId>.xmind" }
```

Cached per (user, contentId). Pass `--isRefresh true` to regenerate.

### Visual analysis

```bash
# 1. Create the task (Pro-only; rate-limited)
bibi call video.visuals --videoUrl "https://..." --json
# → { "taskId":..., "status": "pending"|"processing"|"completed"|... , "isFromCache": ... }

# 2. Poll for completion via the legacy procedure (Phase 2.x.x will add a wrapper)
curl -s -H "Authorization: Bearer $BIBI_API_TOKEN" \
  "https://bibigpt.co/api/trpc/vision.getVideoProcessingTask?input=$(printf %s '{"json":{"taskId":"..."}}' | jq -sRr @uri)"
```

### Custom-prompt summary

```bash
bibi call summary.byPrompt \
  --contentId <contentId> \
  --customPrompt "Top 3 actionable insights" \
  --outputLanguage zh-CN --json
# → { "summary": "...", "fromCache": false }
```

**Side effect**: overwrites the user's saved note for this video. Use `/v1/summarizeWithConfig` directly if you don't want the note clobbered.

### Notion export

```bash
# 1. Confirm Notion is connected
bibi call notion.status --json
# 2. Push
bibi call notion.exportNote --contentId <contentId> --json
# → { "success": true, "pageUrl": "https://www.notion.so/..." }
```

## Notes

- All five tools are **mutations** with `agent.scope = 'write'`; require a token with write scope (Phase 1.6.x runtime check enforced via tRPC middleware).
- Phase 2.7.x / 2.9.x / 2.10.x / 2.11.x all landed simultaneously after Phase 1.6.x scope migration was applied — no more NOT_IMPLEMENTED stubs in this section.
- Custom-prompt summary clobbers `user_contents_note`; use `/v1/summarizeWithConfig` directly when you need a one-shot generation that doesn't touch the saved note.
