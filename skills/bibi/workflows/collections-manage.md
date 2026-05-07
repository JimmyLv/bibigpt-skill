# Workflow: Collections (Curated Video Sets)

Use when the user wants to organize saved videos into collections — think Pinterest boards, Notion databases, or YouTube playlists. Collections can be private to the user, public for sharing, or paid (sold to other users).

## Triggers

- "Make a collection of these videos"
- "Show my collections"
- "Add this video to <collection>"
- "我创建的合集"
- "把这个视频加进 X 合集"
- "Open my purchased collections"

## Steps

### 1. List collections

```bash
bibi collections list --json                   # default: scope=all (owned + purchased)
bibi collections list --scope owned --json
bibi collections list --scope purchased --json
bibi collections list --limit 50 --json
```

Returns `{ collections: [{ id, name, slug, isPublic, videoCount, coverUrl, ownership }], nextCursor }`. `ownership` is `"owned"` or `"purchased"`.

### 2. Get collection details (with items)

```bash
bibi collections get --id <collectionId> --json
```

Returns `{ id, name, description, isPublic, ownership, items: [<savedVideoSummary>], aggregatedSummary }`. Authorization: owner can always view; non-owner needs an active purchase OR the collection must be public.

### 3. Create a collection

```bash
bibi collections create --name "AI Agents 2026" --description "Best videos this year" --isPublic false --json
# → { "id": "..." }
```

Mutation; requires write scope.

### 4. Add a video to a collection

```bash
# By contentId (preferred — already in your library)
bibi collections add-item --collectionId <id> --contentId <contentId> --json

# By sourceUrl (must already be in your library; will return 404 if you haven't summarized it)
bibi collections add-item --collectionId <id> --sourceUrl "https://..." --json
```

Adding the same video twice is idempotent (returns `{ success: true }`). To import a video first, run `bibi summarize <URL>` then add by contentId.

## Error handling

- **403 FORBIDDEN** on `collections.get`: collection is private and not owned/purchased — confirm to the user.
- **404 NOT_FOUND** on `collections.add-item` with sourceUrl: the URL is not in their library — suggest `bibi summarize <URL>` first.
- **403 FORBIDDEN** on `collections.add-item`: only the collection owner can add items.

## Output formatting

For lists, render a Markdown table with name + videoCount + ownership badge. For details, lead with the description, then list items with title + sourceUrl.

## Notes

- `collections.create` and `collections.add-item` are **mutations** (write scope).
- `list` is cursor-paginated by effective-created-at across owned + purchased collections.
- `aggregatedSummary` is populated by a background job; `null` for newly-created collections.
