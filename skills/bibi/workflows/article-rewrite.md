# Article Rewrite

Transform video or audio content into a polished article — directly on the agent side using the transcript, no extra API call needed.

## Triggers

"turn into article", "write blog post from video", "AI改写", "公众号图文", "video to blog", "rewrite as article", "小红书文案", "newsletter from video", "twitter thread"

## Steps

### 1. Get the Transcript

If you already have the transcript/subtitles from a previous step, use it directly.

Otherwise, fetch it first:

**CLI mode:**
```bash
bibi summarize "<URL>" --subtitle --json
```

**API mode:**
```bash
ENCODED=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$URL")
curl -s "https://api.bibigpt.co/api/v1/getSubtitle?url=$ENCODED" \
  -H "Authorization: Bearer $BIBI_API_TOKEN" \
  -H "x-client-type: bibi-cli"
```

Also get the summary for context if available (via `workflows/quick-summary.md`).

### 2. Clarify Article Style

Ask the user which format they want:

| Style | Description |
|-------|-------------|
| **Full article** (default) | 公众号图文 / blog post — structured with headings |
| **Twitter/X thread** | Numbered tweets, high density, hook-driven |
| **Social media copy** | 小红书/short-form — condensed key points |
| **Plain readable text** | Polished transcript, no restructuring |

### 3. Rewrite Directly as the Agent

You already have the transcript. **Do not call the API** — rewrite the content yourself following the prompt guidelines below.

#### For Full Article (公众号/Blog)

Act as an expert copywriter specializing in content optimization for video. Transform the transcript into a well-structured, engaging Markdown article.

**Article goals:**
- Extract and present core viewpoints, arguments, and examples accurately
- Distill and synthesize — do NOT transcribe word-by-word
- Cover ALL content completely — do not summarize only partial sections

**Article structure:**
- **Title**: Concise, compelling, includes keywords
- **Pyramid structure**: Conclusion first, then supporting details
- **3-5 secondary headings** (H2): Each covers a major content section
- Under each heading: summarize the key point first, then elaborate step-by-step
- Conclude each section with a synthesis

**Style:**
- Preserve the original creator's expression style — do not over-edit
- Use Markdown with sub-headings
- Output in the user's requested language (default: same as source)

**Template:**

```markdown
# [Compelling Title]

[Opening paragraph — core thesis / hook]

## [Section 1 Heading]
[Key point summary]
[Detailed elaboration...]

## [Section 2 Heading]
[Key point summary]
[Detailed elaboration...]

## [Section 3 Heading]
...

## Summary
[Key takeaways]
```

#### For Twitter/X Thread

Transform the video content into a Chinese tweet thread:

- **Hook first**: The opening tweet must grab curiosity like a "钩子"
- **High density**: Each tweet = one core insight, no info overload
- **Minimal emoji**: Max 1-2 emoji for emphasis, avoid exclamation marks
- **Logical flow**: Use questions as transitions between tweets for rhythm
- **Strong close**: Final tweet summarizes or poses an open question for discussion
- **CTA**: Encourage likes, retweets, comments, or follows
- **1-2 relevant #Hashtags** for discoverability

**Format:**
```
1/ [Hook tweet — grab attention]
---
2/ [Core insight 1]
---
3/ [Core insight 2]
...
7/ [Summary + CTA] #Hashtag1 #Hashtag2
```

- Max 7 tweets
- Max 280 chars (English) or 140 chars (Chinese) per tweet

#### For Social Media Copy (小红书)

- Condensed key points with visual-friendly formatting
- Short paragraphs, bullet points
- Conversational tone
- Include relevant tags/keywords at the end

#### For Plain Readable Text

Polish the transcript into readable paragraphs:
- Add proper punctuation
- Fix transcription errors (common with Whisper ASR: homophones, filler words)
- Remove filler words (呃, 诶, 哎, 啊, 然后, 那种, 其实, 可能, 比较, 这个)
- Add paragraph breaks at natural topic shifts
- **Bold formatting**: Only bold complete phrases/sentences (core conclusions), max 1-2 per paragraph, never bold single words
- Preserve original expression and timestamps

### 4. Present the Result

- Show the rewritten article in Markdown
- Include source attribution: original video title + URL
- If the user specified a language, ensure output matches

### 5. Follow-up Options

- "Save to Notion or Obsidian" → `workflows/export-notes.md`
- "Get the original transcript" → `workflows/transcript-extract.md`
- "Summarize another video" → `workflows/quick-summary.md`
- "Rewrite in a different style" — re-run step 3 with a different format
- "Translate to another language" — re-run with target language specified
