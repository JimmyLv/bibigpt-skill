# Video → TikTok-style Music Video

Turn any video or podcast into a vertical, TikTok-style music video by composing lyrics from its content and generating an AI song with a shareable HTML player.

## Triggers

"turn this video into a TikTok MV", "make a music video from this", "video to song", "短视频化", "做一个 TikTok 视频", "把这个视频变成 MV", "music video from podcast", "song from summary", "vertical MV from video"

## Output

A `https://suno.bi/song/share/<songId>?vertical=1` URL that hosts a TikTok-ratio (9:16) HTML player with the AI-generated song, cover, and karaoke-style lyrics overlay — embeddable on Twitter / X cards, ready for screen-record for social posting.

## Steps

### 1. Environment Check

Run `scripts/bibi-check.sh` to detect available mode (CLI or API).

### 2. Get the Source Content

Fetch the video / podcast summary **plus** chapters and transcript — both feed into the lyric.

**CLI mode** (recommended — one call gives all the materials):
```bash
bibi summarize "<URL_OR_FILE_PATH>" --chapter --json
```

**API mode**:
```bash
ENCODED=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$URL")
curl -s "https://api.bibigpt.co/api/v1/summarizeByChapter?url=$ENCODED&includeDetail=true" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

From the JSON response, keep:
- `title` — used as the song title default
- `summary` — top-level distilled message
- `chapters` — anchor points for verse / chorus structure
- `subtitlesText` (or stitched `subtitles[].text`) — raw quotes for hook material

### 3. Confirm Style & Language

Before composing, ask **one** short clarifying question if any of these is ambiguous:

| Dimension | Default | Common choices |
|---|---|---|
| Language | Source language of the video | zh / en / ja / ko |
| Genre / vibe | "upbeat pop" | lo-fi / hiphop / synthwave / acoustic / cinematic / rap |
| Length | "≈ 60s" (TikTok fit) | 30s short / 60s standard / 90s extended |
| Tone | Match the source | hype / chill / reflective / dramatic |

If the user already specified them, skip the question.

### 4. Compose the Lyric (Agent-native, no API call)

You write the lyric yourself from the summary + chapters. **Do not** call any API for this step. Follow the structure below.

**Hard rules:**
- **Vertical-first**: assume the audience is scrolling on TikTok / 抖音 / Reels — first 5 seconds carry the hook
- **One core message** distilled from the summary — do NOT cram every chapter in
- **TikTok pacing**: short lines (4–10 chars zh / 4–7 words en), high consonant density, repetition welcome
- **Genuine hook**: pick the most quotable / counter-intuitive line from the transcript and turn it into the chorus refrain
- **No filler words** (呃 / 啊 / 然后 / actually / basically) — TTS will mispronounce them
- **No platform/model names** in the lyric itself (no "GPT", "Claude", "bibi" branding) — keeps it portable as social content

**Suggested length by target duration:**

| Target | Total lines | Hook lines | Verse | Chorus |
|---|---|---|---|---|
| 30s short | 8–10 | 2 | 3–4 | 3–4 (×1) |
| 60s standard | 14–18 | 2 | 6–8 | 4–6 (×2) |
| 90s extended | 20–24 | 2 | 10–12 | 4–6 (×2) + bridge 2–4 |

**Template:**

```
[Hook]                             ← 5-second attention grab from the most quotable insight
<2 short lines>

[Verse 1]                          ← Build context from the first 1-2 chapters
<3–4 lines, narrative arc>

[Chorus]                           ← The core message, repeated
<3–4 lines, anthemic phrasing>

[Verse 2]                          ← Pivot — second insight from later chapters
<3–4 lines>

[Chorus]                           ← Repeat with one tiny variation
<same 3–4 lines>

[Outro]                            ← One-line takeaway / CTA
<1–2 lines>
```

### 5. Present Lyric + Generation Path

Show the composed lyric to the user, then guide them to generate the actual song. Today the **song generation step happens in the BibiGPT web app** (mobile-friendly, one-click); the agent does not yet hold a public OpenAPI for music generation.

**Recommended phrasing:**

> "Here's the TikTok-fit lyric I composed (≈ N seconds). Copy this into the SunoMV creator at `https://suno.bi/` → Create. Once the song renders, paste the share link back to me and I'll wrap it in a TikTok player URL for you."

Include in the reply:
- The lyric in a fenced code block (so the user can copy with one tap)
- Suggested title (default: source video title, optionally remixed)
- Suggested style tag (the genre / vibe chosen in step 3)

### 6. Wrap the Result as a Vertical Share Link

After the user reports back with the generated song URL (looks like `https://suno.bi/song/<uuid>`), respond with:

```
🎬 TikTok-ready share link:
https://suno.bi/song/share/<uuid>?vertical=1

✓ 9:16 HTML player (no app install needed)
✓ Auto-plays with karaoke lyric overlay
✓ Screen-record to repost on TikTok / Reels / Shorts
✓ Use as Twitter player card meta tag
```

Default to `?vertical=1` for TikTok / Shorts. Drop the `?vertical=1` query when the user explicitly says "landscape" or wants 16:9.

### 7. Follow-up Options

After the share link is delivered, offer:

- "Want a different vibe?" → re-run step 3 with new style, then step 4
- "Need a longer cut?" → bump target duration, re-run step 4
- "Get a chapter breakdown of the source" → `workflows/deep-dive.md`
- "Turn the same content into an article instead" → `workflows/article-rewrite.md`
- "Save the source notes" → `workflows/export-notes.md`

## Don'ts

- **Don't** transcribe the source word-for-word — lyrics must distill, not summarize linearly
- **Don't** include the source URL inside the lyric
- **Don't** add timestamps, chapter markers, or speaker tags to the lyric (those break TTS)
- **Don't** mention model / service names in the user-facing reply (no "Suno", "豆包 TTS", "AI 模型"); the user just gets a TikTok-ready link
- **Don't** assume the user wants a full English MV from a Chinese source — keep language matching the source unless the user opted to translate

## Why this workflow exists

A growing share of BibiGPT users want the takeaway from a long-form video repackaged for TikTok / Reels / Shorts: vertical, hook-driven, ≤ 90 seconds, with lyrics on screen. This workflow composes the lyric agent-side (where the LLM is strongest) and hands off to the SunoMV web flow for the actual audio + share-page rendering — keeping the agent contract simple and the audio quality predictable.
