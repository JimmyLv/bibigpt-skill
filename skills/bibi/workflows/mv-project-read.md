# Workflow: Read a SunoMV Music Video Project

Use this when the user asks where their music video project stands, who appears in which shots, which shots failed, or wants the project as structured JSON (for review, debugging, or planning edits).

## Triggers

- "How far along is my music video?"
- "Which shots is the boy in?"
- "Why did shot 7 fail?"
- "Export my MV project as JSON"
- "我的 MV 做到哪一步了？" / "男孩出现在哪几镜？" / "导出工程 JSON"

## Environment Check

Run `scripts/bibi-check.sh`. Authentication is required — this reads the user's own project only.

## Steps

The song ID is the `<id>` in `https://suno.bi/song/<id>`.

```bash
curl -s "https://api.bibigpt.co/api/v1/getMvProject?contentId=<SONG_ID>" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

MCP clients can call the `get_mv_project` tool with `{ "contentId": "<SONG_ID>" }`.

## Response (abridged)

```json
{
  "dslVersion": 1,
  "contentId": "…",
  "options": { "styleName": "Cinematic", "aspectRatio": "16:9" },
  "workflow": {
    "currentStep": "stills",
    "doneCount": 4,
    "totalCount": 7,
    "exportable": false,
    "steps": [{ "id": "stills", "status": "running", "done": 12, "total": 20, "failed": 1, "spendGuard": true }]
  },
  "cast": [{ "id": "bible-1", "name": "Son", "appearsIn": [0], "scope": "some" }],
  "shots": [
    {
      "index": 0,
      "lyric": "you were small",
      "prompt": "…",
      "promptSource": "script",
      "action": "The mother hugs her son.",
      "mood": "tender",
      "cast": ["ref-mom", "bible-1"],
      "still": { "status": "completed", "versions": 2 }
    }
  ],
  "clips": [{ "index": 0, "shotIndexes": [0, 1], "video": { "status": "completed", "usable": true, "versions": 1 } }]
}
```

Field notes:

- `workflow.steps[].id`: `song` → `direction` → `cast` → `storyboard` → `stills` → `clips` → `final`. `spendGuard: true` marks steps that spend credits.
- `cast[].appearsIn` lists shot indexes (0-based). `scope` is `all` / `some` / `none`.
- `shots[].prompt` is the exact text used to paint the still. `promptSource: "override"` means the user rewrote it by hand.
- `shots[].actionOutOfSync: true` means the summary no longer matches the prompt — trust `prompt`.
- Unknown future fields may appear; ignore what you don't recognize.

## How to answer

- Progress questions: name the current step in plain words and the count (e.g. "12 of 20 stills are painted, 1 failed").
- Cast questions: answer with shot numbers counted from 1 (`appearsIn + 1`).
- Failures: quote `still.error` / `video.error` in plain words and suggest the user edit that shot's description before repainting.
- This endpoint is **read-only**. Changing the project still happens in the SunoMV editor at `https://suno.bi/`.

## Don'ts

- Don't show raw JSON unless the user asked for it.
- Don't name image or video models in the reply.
