import assert from 'node:assert/strict'
import { test } from 'node:test'

const { loadPackagedSkill } = await import('./index.js').then(async (m) => {
  // loadPackagedSkill is module-private; exercise it through apply() with a
  // stub context, which is also the contract dsh actually calls.
  return { loadPackagedSkill: null, ...m }
})

/** Minimal stand-in for the pieces of the Cordis context this plugin touches. */
function stubContext() {
  const registered = []
  const logs = []
  const effects = []
  return {
    ctx: {
      skills: {
        register(skill) {
          registered.push(skill)
          return () => registered.splice(registered.indexOf(skill), 1)
        },
      },
      logger: {
        info: (...args) => logs.push(['info', ...args]),
        warn: (...args) => logs.push(['warn', ...args]),
      },
      effect(fn) {
        effects.push(fn())
      },
    },
    registered,
    logs,
    effects,
  }
}

test('registers the bibi skill with a usable description and resource base', async () => {
  const { apply } = await import('./index.js')
  const { ctx, registered } = stubContext()

  apply(ctx)
  // apply() registers from a promise inside ctx.effect; let it settle.
  await new Promise((r) => setTimeout(r, 50))

  assert.equal(registered.length, 1, 'exactly one skill should register')
  const skill = registered[0]

  assert.equal(skill.name, 'bibi')
  assert.equal(skill.source, 'bundled')
  assert.ok(skill.description.length > 40, 'folded YAML description should be joined, not truncated')
  assert.ok(!skill.description.includes('\n'), 'folded description should be a single line')
  assert.ok(!skill.content.startsWith('---'), 'frontmatter should be stripped from the body')
  assert.ok(skill.content.length > 100, 'skill body should survive')
  assert.equal(skill.resourceBase?.kind, 'directory', 'references/ and scripts/ need a directory base')
  assert.ok(skill.path.endsWith('SKILL.md'))
})

test('unregisters when the effect is disposed', async () => {
  const { apply } = await import('./index.js')
  const { ctx, registered, effects } = stubContext()

  apply(ctx)
  await new Promise((r) => setTimeout(r, 50))
  assert.equal(registered.length, 1)

  for (const dispose of effects) dispose?.()
  assert.equal(registered.length, 0, 'disposing the plugin should remove the skill')
})

test('does nothing when the skills service is absent', async () => {
  const { apply } = await import('./index.js')
  assert.doesNotThrow(() => apply({ logger: { info() {}, warn() {} }, effect() {} }))
})
