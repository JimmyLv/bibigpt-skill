# Workflow: Collections (Curated Video Sets)

Use when the user wants to organize saved videos into collections — think Pinterest boards, Notion databases, or YouTube playlists. Collections can be private to the user, public for sharing, or paid (sold to other users).

## Triggers

- "Make a collection of these videos"
- "Show my collections"
- "Add this video to <collection>"
- "我创建的合集"
- "把这个视频加进 X 合集"
- "Open my purchased collections"
- "Tidy up my collections" / "整理一下我的合集"
- "Move this folder to the top level" / "把这个文件夹移到根目录"
- "Rename this collection" / "把这几条移到另一个合集"

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

### 5. Read the folder tree

Collections double as folders: a collection can sit inside another one (up to 4 levels).

```bash
bibi collections folders --json
# → { folders: [{ id, name, emoji, parentId, depth }] }   parentId null = top level
```

### 6. Create a sub-folder / move a folder

```bash
bibi collections create --name "Agents" --parentId <folderId> --json
bibi collections move --collectionId <id> --newParentId <folderId> --json
bibi collections move --collectionId <id> --newParentId null --json     # move to the top level
```

A folder moves together with its sub-folders. The server rejects moving a folder into itself or one of its own sub-folders, and moves that would go deeper than 4 levels.

### 7. Rename or edit a collection

```bash
bibi collections update --collectionId <id> --name "AI Agents" --emoji "🤖" --json
bibi collections update --collectionId <id> --description "..." --json
```

`--isPublic true|false` publishes or unpublishes the collection. Only change it when the user asks for it in so many words.

### 8. Move items between collections

Use the item ids returned by `collections get` (`items[].id`).

```bash
bibi collections move-items --sourceCollectionId <a> --targetCollectionId <b> --contentIds '["id1","id2"]' --json
bibi collections move-items --sourceCollectionId <a> --targetCollectionId <b> --contentIds '["id1"]' --mode copy --json   # keep them in the source too
bibi collections remove-items --collectionId <id> --contentIds '["id1"]' --json
bibi collections for-content --contentId <contentId> --json   # which collections hold this video
```

`--contentIds` is always a JSON array, even for one id. `remove-items` only takes items out of the collection; the videos stay in the library. Items already in the target count as `duplicates`; ids not in the source count as `notInCollection`.

### Organizing a whole library

1. Read first: `collections folders` + `collections list` (+ `collections get` for the ones you plan to touch).
2. Show the user the plan as a short before → after list (which folders move, which items go where).
3. Apply only after the user agrees. Report what changed and anything that was skipped.

Deleting a collection is not available to agents; send the user to the web app for that.

## Error handling

- **403 FORBIDDEN** on `collections.get`: collection is private and not owned/purchased — confirm to the user.
- **404 NOT_FOUND** on `collections.add-item` with sourceUrl: the URL is not in their library — suggest `bibi summarize <URL>` first.
- **403 FORBIDDEN** on `collections.add-item`: only the collection owner can add items.
- **400 BAD_REQUEST** on `collections.move`: the target is the folder itself, one of its sub-folders, or would exceed 4 levels — pick another target.
- **404 NOT_FOUND** on `collections.move-items` / `remove-items`: none of the ids are in that collection — re-read it with `collections get`.

## Output formatting

For lists, render a Markdown table with name + videoCount + ownership badge. For details, lead with the description, then list items with title + sourceUrl.

## Notes

- `create`, `add-item`, `move`, `update`, `move-items`, `remove-items` are **mutations** (write scope).
- `list` is cursor-paginated by effective-created-at across owned + purchased collections.
- `aggregatedSummary` is populated by a background job; `null` for newly-created collections.
