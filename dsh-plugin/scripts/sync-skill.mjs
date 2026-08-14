#!/usr/bin/env node
/**
 * Copy the repository's `skills/bibi` bundle into this package so the published
 * artifact carries it. The repository copy stays the single source of truth —
 * this directory is a build artifact and is gitignored.
 *
 * Runs on `prepare`, which covers every install path that matters:
 * `npm pack`/`publish`, and installs straight from git (npm and pnpm both run
 * `prepare` for git dependencies, including pnpm's `#path:` subdirectory form).
 * Run it by hand with `npm run sync-skill`.
 *
 * Exits 0 when the source is missing but a bundle is already in place — that's
 * the tarball case, where the copy shipped inside the package and there is no
 * repository around it.
 */
import { cp, rm, stat } from 'node:fs/promises'
import { dirname, join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const here = dirname(fileURLToPath(import.meta.url))
const source = resolve(here, '../../skills/bibi')
const target = resolve(here, '../skills/bibi')

/** @param {string} dir @returns {Promise<boolean>} whether dir holds a readable SKILL.md */
async function hasBundle(dir) {
  try {
    return (await stat(join(dir, 'SKILL.md'))).isFile()
  } catch {
    return false
  }
}

if (!(await hasBundle(source))) {
  if (await hasBundle(target)) {
    console.log('sync-skill: no repository source; keeping the packaged bundle')
    process.exit(0)
  }
  console.error(`sync-skill: no skill bundle at ${source} and none packaged at ${target}`)
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
