---
tags: [vibecraft, board]
updated: 2026-10-09
---

# Board

Maintained by Chief. One line per task, one owner, newest milestone first. Legend: `[ ]` backlog · `[~]` doing ·
`[r]` in review by Chief · `[x]` done (date) · `[!]` blocked (say why). Agents move their own items; only Chief
adds milestones or reorders. Design in [[architecture]], process in [[agent-protocol]].

## Gate 0 — kickoff (user + Chief)
- [ ] Chief walks the user through launching all four agents (`bash scripts/spawn-agents.sh`) and confirms each has reported in
- [ ] User confirms or overrules the ten defaults in `docs/notes/architecture.md` §16 — **blocks all M0 code**
- [ ] Chief records the answers (ADRs) and writes one M0 kickoff handoff per agent

## M0 — Foundations (target first integration: 2026-10-16)

### Chief
- [x] Architecture, ADRs, agent protocol, agents, worktrees, spawn script (2026-10-09)
- [ ] `packages/contracts` v0: namespaced ids, `GameEvent` union, protocol packet enum + `Hello/Welcome/Input/ChunkData` types, JSON schemas for `blocks`, `items`, `sound-events`, `models`, save version
- [ ] Root workspace config: `package.json` workspaces, `tsconfig.base.json`, ESLint boundaries (§2.1), Prettier, `npm run check`
- [ ] First integration: merge all three agent branches, run gates, demo to user

### Code Master
- [ ] Scaffold `apps/web` (Vite, landing stub, `play.html`, boot chunk), `packages/{core,world,sim,net,renderer,ui,storage}` with `index.ts` and smoke tests
- [ ] `core`: vec3/aabb/ray, xoshiro RNG, OpenSimplex2, EventBus, Logger (tests)
- [ ] `renderer`: WebGL2 context, `TEXTURE_2D_ARRAY` loader, chunk shader, hello-chunk (flat 16³), fly camera, `?perf=1` overlay skeleton
- [ ] `net`: `Transport` interface, `LocalTransport` over MessageChannel, codec for `Hello/Welcome` round-trip (tests)
- [ ] `tools/content/validate`: validate `content/*.json` against contracts schemas
- [ ] `packages/mcp-server` skeleton: `game.status`, `render.screenshot` over the dev bridge (port 8766)

### Visual Arts Master
- [ ] `docs/notes/art-direction.md`: style pillars, master palette (`assets/art/palette.hex`), light direction, texture rules, UI rules, landing concept
- [ ] First 16 block textures (stone, dirt, grass top/side, sand, gravel, oak log side/top, oak planks, oak leaves, water, cobble, coal ore, iron ore, glass, bedrock-equivalent) at 16×16
- [ ] `tools/art/pack-blocks`: PNG dir → texture array strip + `blocks.json` index, validation (size, palette, naming)
- [ ] PWA icon set + favicon + placeholder og image

### Sound Master
- [ ] `docs/notes/sound-design.md`: pillars, bus layout, loudness targets, naming, environment chain spec
- [ ] `packages/audio` skeleton: `AudioEngine` (context, buses, limiter), `SoundEventRouter`, asset loader with format fallback (tests with `OfflineAudioContext`)
- [ ] `content/sound-events.json` v0 with `ui.click`, `ui.hover`, `block.stone.{step,break,place}` + schema in contracts (request to Chief)
- [ ] `tools/sound/encode`: WAV → ogg + m4a + manifest; first 6 original SFX

## M1 — Walkable World
- [ ] (Chief) break down after M0 demo

## M2 — Survival Core · M3 — Shell & Persistence · M4 — Multiplayer · M5 — Polish & Release
See [[architecture]] §15. Broken down when the previous milestone exits.
