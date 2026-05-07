# Workflow: Advanced Tools (Mindmap / Visuals / By-Prompt / Notion / Chat)

Higher-value but lower-frequency capabilities. Each maps to a single CLI invocation or MCP tool call; pick by intent.

## Triggers and routing

| Intent | Command |
|---|---|
| "Make a mindmap from this summary" | `bibi call video.mindmap --contentId <id> --summary "..."` — returns `.xmind` file URL; cached per (user, contentId) |
| "Analyze the visuals / slides / on-screen text" | `bibi call video.visuals --videoUrl "https://..."` — Pro-only; rate-limited; returns taskId, poll `vision.getVideoProcessingTask` for completion |
| "Re-summarize with my own prompt" | `bibi call summary.byPrompt --contentId <id> --customPrompt "..."` — always regenerates; overwrites the user's saved note |
| "Push this video summary to Notion" | `bibi call notion.exportNote --contentId <id>` — requires prior Notion OAuth (check via `notion.status`); creates a new page in the bound database |
| "Show me the chat history for collection X" | `bibi call collections.chatHistory --collectionId <id>` — returns prior messages + AI-suggested questions |

## Steps

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

### 3. Notion export

```bash
bibi call notion.exportNote --contentId <id> --json
# → { "success": true, "pageUrl": "https://www.notion.so/..." }
```

Validates that the note exists and Notion is connected, then creates a new Notion page in the bound database. Returns the page URL on success.

## Working examples

### Mindmap

```bash
bibi call video.mindmap \
  --contentId <contentId> \
  --summary "$(bibi call notes.get --contentId <contentId> --json | jq -r .note)" --json
# → { "fileUrl": "https://...storage.../<userId>/<contentId>.xmind" }
```

Cached per (user, contentId). Pass `--isRefresh true` to regenerate.

### Visual analysis

```bash
# 1. Create the task (Pro-only; rate-limited)
bibi call video.visuals --videoUrl "https://..." --json
# → { "taskId":..., "status": "pending"|"processing"|"completed"|... }

# 2. Poll for completion (legacy procedure — agent wrapper coming)
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
bibi call notion.status --json                  # confirm connection
bibi call notion.exportNote --contentId <contentId> --json
# → { "success": true, "pageUrl": "https://www.notion.so/..." }
```

## Notes

- All five tools are **mutations** with `agent.scope = 'write'`; require a token with write scope. Read-only tokens get 403.
- Custom-prompt summary clobbers `user_contents_note`; use `/v1/summarizeWithConfig` directly when you need a one-shot generation that doesn't touch the saved note.
