import { readFile, stat } from 'node:fs/promises'
import { dirname, join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

export const name = 'bibigpt'
export const inject = ['skills']

const HERE = dirname(fileURLToPath(import.meta.url))

/**
 * Where the packaged skill bundle may live.
 *
 * `skills/bibi` is what `npm pack` ships (written by scripts/sync-skill.mjs).
 * `../skills/bibi` is the repository's own copy, so a clone can be installed
 * with `dsh plugin add ./dsh-plugin` before anything has been synced.
 */
const CANDIDATE_DIRS = ['skills/bibi', '../skills/bibi']

const FRONTMATTER = /^---\r?\n([\s\S]*?)\r?\n---\r?\n?/

/**
 * Read the `name` and `description` keys out of a YAML frontmatter block.
 *
 * Deliberately not a YAML parser: the plugin ships with zero dependencies, and
 * the two keys it needs are always either an inline scalar or a `>`/`|` block
 * whose continuation lines are indented. Anything else is left to the loader.
 *
 * @param {string} block - the text between the `---` fences.
 * @returns {Record<string, string>} the scalar keys that could be resolved.
 */
function readFrontmatterScalars(block) {
  /** @type {Record<string, string>} */
  const out = {}
  const lines = block.split(/\r?\n/)

  for (let i = 0; i < lines.length; i += 1) {
    const match = /^([A-Za-z][\w-]*):[ \t]*(.*)$/.exec(lines[i])
    if (match === null) continue

    const key = match[1]
    const inline = match[2].trim()

    // An inline scalar that is not a block indicator ends the key right here.
    if (inline !== '' && inline !== '>' && inline !== '|' && !inline.startsWith('>') && !inline.startsWith('|')) {
      out[key] = inline.replace(/^['"]|['"]$/g, '')
      continue
    }

    const folded = []
    for (let j = i + 1; j < lines.length; j += 1) {
      const line = lines[j]
      if (line.trim() === '') {
        folded.push('')
        continue
      }
      // A non-indented line starts the next key.
      if (!/^[ \t]/.test(line)) break
      folded.push(line.trim())
      i = j
    }
    const joined = folded.join(' ').replace(/\s+/g, ' ').trim()
    if (joined !== '') out[key] = joined
  }

  return out
}

/**
 * Locate the packaged skill and shape it into a `SkillRegistration`.
 *
 * Registering at runtime rather than pointing `dsh-skill-filesystem` at another
 * root keeps this bundle from having to restate that plugin's whole config: a
 * patch row replaces `config` wholesale, so contributing a directory there
 * would fight every other bundle that wants to own the same row.
 *
 * @returns {Promise<object | undefined>} the registration, or undefined when no readable bundle exists.
 */
async function loadPackagedSkill() {
  for (const candidate of CANDIDATE_DIRS) {
    const dir = resolve(HERE, candidate)
    const path = join(dir, 'SKILL.md')

    let raw
    try {
      raw = await readFile(path, 'utf8')
    } catch {
      continue
    }

    const match = FRONTMATTER.exec(raw)
    if (match === null) return undefined

    const { name: skillName, description } = readFrontmatterScalars(match[1])
    if (skillName === undefined || description === undefined) return undefined

    // `references/` and `scripts/` sit next to SKILL.md and the body links to
    // them by relative path, so the directory has to travel with the skill.
    let resourceBase
    try {
      if ((await stat(dir)).isDirectory()) resourceBase = { kind: 'directory', path: dir }
    } catch {
      // A flat SKILL.md still registers; only the relative links go dark.
    }

    return {
      name: skillName,
      description,
      content: raw.replace(FRONTMATTER, ''),
      source: 'bundled',
      path,
      ...(resourceBase === undefined ? {} : { resourceBase }),
    }
  }

  return undefined
}

/**
 * @param {import('@deepseek-ai/cordis').Context} ctx - the plugin context, with `skills` injected.
 */
export function apply(ctx) {
  if (ctx.skills === undefined) return

  const skills = ctx.skills
  let dispose
  let disposed = false

  ctx.effect(() => {
    loadPackagedSkill()
      .then((skill) => {
        if (disposed || skill === undefined) {
          if (skill === undefined) ctx.logger.warn('bibigpt: no readable skill bundle found; nothing registered')
          return
        }
        dispose = skills.register(skill)
        ctx.logger.info('bibigpt: registered the "%s" skill', skill.name)
      })
      .catch((e) => {
        ctx.logger.warn('bibigpt: failed to register the packaged skill: %o', e)
      })

    return () => {
      disposed = true
      dispose?.()
    }
  })
}
