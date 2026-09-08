#!/usr/bin/env node
/**
 * Copy every repository `skills/<name>` bundle into this package so the
 * published artifact carries them. The repository copy stays the single
 * source of truth — this directory is a build artifact and is gitignored.
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
import { cp, readdir, rm, stat } from 'node:fs/promises'
import { dirname, join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const here = dirname(fileURLToPath(import.meta.url))
const skillsRoot = resolve(here, '../../skills')
const targetRoot = resolve(here, '../skills')

/** @param {string} dir @returns {Promise<boolean>} whether dir holds a readable SKILL.md */
async function hasBundle(dir) {
  try {
    return (await stat(join(dir, 'SKILL.md'))).isFile()
  } catch {
    return false
  }
}

/** @param {string} root @returns {Promise<string[]>} */
async function skillNames(root) {
  try {
    const entries = await readdir(root, { withFileTypes: true })
    const names = []
    for (const entry of entries) {
      if (entry.isDirectory() && (await hasBundle(join(root, entry.name)))) {
        names.push(entry.name)
      }
    }
    return names.sort()
  } catch {
    return []
  }
}

const sources = await skillNames(skillsRoot)
if (sources.length === 0) {
  if ((await skillNames(targetRoot)).length > 0) {
    console.log('sync-skill: no repository source; keeping the packaged bundle')
    process.exit(0)
  }
  console.error(`sync-skill: no skill bundles at ${skillsRoot} and none packaged at ${targetRoot}`)
  process.exit(1)
}

for (const name of sources) {
  const source = join(skillsRoot, name)
  const target = join(targetRoot, name)
  await rm(target, { recursive: true, force: true })
  await cp(source, target, { recursive: true })
  const manifest = join(target, 'SKILL.md')
  try {
    await stat(manifest)
  } catch {
    console.error(`sync-skill: ${manifest} missing after copy`)
    process.exit(1)
  }
  console.log(`sync-skill: ${source} -> ${target}`)
}
