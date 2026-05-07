# Workflow: Advanced Tools (Mindmap / Visuals / By-Prompt / Notion / Chat)

Bridges high-value but lower-frequency capabilities. Most are MVP-staged — schemas and routing exist, full implementation lands in later sub-phases. The procedures emit **clear NOT_IMPLEMENTED messages** with the exact fallback when not yet ready, so the agent can degrade gracefully.

## Triggers and routing

| Intent | Phase | Today |
|---|---|---|
| "Make a mindmap from this summary" | 2.11 → 2.11.x | NOT_IMPLEMENTED — fall back to `vision.xmind` via tRPC client |
| "Analyze the visuals / slides / on-screen text" | 2.7 → 2.7.x | NOT_IMPLEMENTED — fall back to `vision.createVideoProcessingTask` |
| "Re-summarize with my own prompt" | 2.9 → 2.9.x | NOT_IMPLEMENTED — fall back to `/v1/summarizeWithConfig` with `promptConfig.customPrompt` |
| "Push this video summary to Notion" | 2.10 → 2.10.x | Pre-flight checks pass (note + connection); page upsert deferred to 2.10.x. Today, call `notion.sendToNotion` via tRPC |
| "Show me the chat history for collection X" | 2.8 | ✅ Working — `bibi call collections.chatHistory --collectionId <id>` |

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

## Steps — graceful fallbacks for deferred items

### Mindmap (Phase 2.11.x pending)

```bash
# Today, via tRPC client:
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"json":{"summary":"...","contentId":"...","isRefresh":false}}' \
  "https://bibigpt.co/api/trpc/vision.xmind"
```

### Visual analysis (Phase 2.7.x pending)

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"json":{"videoUrl":"https://...","speed":1,"force":false}}' \
  "https://bibigpt.co/api/trpc/vision.createVideoProcessingTask"
```

Then poll `vision.getVideoProcessingTask` with the returned `taskId` until status is `completed`.

### Custom-prompt summary (Phase 2.9.x pending)

Use the existing `/v1/summarizeWithConfig` endpoint (already exposed):

```bash
curl -s -X POST -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"url":"https://...","promptConfig":{"customPrompt":"Top 3 actionable insights"}}' \
  "https://bibigpt.co/api/v1/summarizeWithConfig"
```

## Notes

- These tools are mostly **mutations** with `agent.scope = 'write'`; require a token with write scope (Phase 1.6.x runtime check).
- Schemas are stable — once Phase 2.x.x extracts the helpers, the agent endpoint behavior changes from NOT_IMPLEMENTED to actual execution **without changing the input/output contract**. So your agent code written today won't break.
