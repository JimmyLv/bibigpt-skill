#!/usr/bin/env node
/**
 * Copy the repository's `skills/bibi` bundle into this package so `npm pack`
 * can ship it. The repository copy stays the single source of truth — this
 * directory is a build artifact and is gitignored.
 *
 * Runs automatically on `prepack`; run it by hand with `npm run sync-skill`.
 */
import { cp, rm, stat } from 'node:fs/promises'
import { dirname, join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const here = dirname(fileURLToPath(import.meta.url))
const source = resolve(here, '../../skills/bibi')
const target = resolve(here, '../skills/bibi')

try {
  if (!(await stat(source)).isDirectory()) throw new Error('not a directory')
} catch {
  console.error(`sync-skill: no skill bundle at ${source}`)
  process.exit(1)
}

await rm(target, { recursive: true, force: true })
await cp(source, target, { recursive: true })

// The packaged copy must carry its own frontmatter; a stub would register a
// skill whose body says nothing.
const manifest = join(target, 'SKILL.md')
try {
  await stat(manifest)
} catch {
  console.error(`sync-skill: ${manifest} missing after copy`)
  process.exit(1)
}

console.log(`sync-skill: ${source} -> ${target}`)
