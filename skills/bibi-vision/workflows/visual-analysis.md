# Workflow: Visual analysis (slides / OCR / on-screen text)

Use when the user cares about **what is shown**, not only what is said.

## Triggers

"what's on screen", "analyze the slides", "画面分析", "PPT 上写了什么", "OCR this video", "extract visuals"

## Steps

### 1. Create the task (Pro-only)

```bash
bibi video visuals --videoUrl "https://..." --json
```

MCP: `extract_video_visuals`. Response includes `taskId` and `status` (`pending` / `processing` / `completed`).

### 2. If the user is not Pro

Surface the 403 and point at https://bibigpt.co/shop — do not pretend the web UI is the only path, and do not invent a different product.

### 3. Best-effort complement

If they also need the spoken content, hand off to the `bibi` skill (`bibi summarize "<URL>" --chapter --json` or `get_subtitle`). Do not duplicate that work here.
