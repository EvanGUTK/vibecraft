# VibeCraft — repo rules

Browser-native, offline-first voxel sandbox (Minecraft-inspired). Read `docs/notes/architecture.md` before touching
anything. The four agents and how they coordinate are in `docs/notes/agent-protocol.md`. Global rules in
`~/.claude/CLAUDE.md` still apply; this file adds repo facts.

## Status
Architecture phase (2026-10-09). No product code yet. Commands below exist once the M0 scaffold lands; until then
`npm run ...` will fail and that is expected.

## Commands (after M0)
- `npm install` — install all workspaces (npm workspaces, Node 24).
- `npm run dev` — web app on `http://0.0.0.0:5173` (open `http://localhost:5173`).
- `npm run server` — dedicated multiplayer server on `ws://0.0.0.0:8765`.
- `npm run mcp` — dev MCP server (stdio) bridging to the running game on port 8766.
- `npm run assets` — run the art + sound pipelines (atlas, sprite sheets, audio encode, manifests).
- `npm run check` — typecheck + lint + unit tests. Must pass before any merge into `integration`.
- `npm run test:e2e` — Playwright end-to-end (needs a built app).

## Ports
5173 web dev · 4173 web preview · 8765 game server (WebSocket) · 8766 dev bridge (MCP ↔ game). Bind `0.0.0.0`.

## Structure (see architecture §3 for the full tree)
`apps/web` playable site · `apps/server` dedicated server · `packages/*` engine libraries · `packages/contracts`
shared types/protocol/schemas · `assets/art` and `assets/sound` source assets · `content/` data-driven game
definitions · `tools/` asset pipelines · `docs/notes/` living docs · `.claude/agents/` the four agents.

## Ownership (who may edit what)
| Path | Owner |
|---|---|
| `docs/`, `.claude/`, `scripts/`, root configs, `packages/contracts/` | Chief |
| `apps/`, `packages/{core,world,sim,net,renderer,ui,storage,mcp-server}`, `content/*.json` (gameplay data), `tools/content/` | Code Master |
| `assets/art/**`, `tools/art/**`, `content/models/**`, `docs/notes/art-direction.md` | Visual Arts Master |
| `assets/sound/**`, `packages/audio/**`, `content/sound-events.json`, `tools/sound/**`, `docs/notes/sound-design.md` | Sound Master |

To change something you do not own, write a request in `docs/notes/handoffs/` (format in agent-protocol) or ask
Chief. Never edit another agent's paths directly.

## Branches and worktrees
- `main` is protected. Only the user promotes `integration` → `main`.
- `integration` is Chief's branch and worktree (`.worktrees/chief`). All agent work merges here after review.
- `agent/code-master`, `agent/visual-arts-master`, `agent/sound-master` live in `.worktrees/<name>`.
- All worktrees share one `.git`. `git merge integration` pulls in everyone else's work.
- Remote: private `github.com/EvanGUTK/vibecraft` (backup and machine-to-machine transfer; only the user pushes;
  no PRs or CI yet). Worktrees are gitignored and never pushed. After a clone run `bash scripts/setup-worktrees.sh`;
  it rebuilds all four from the pushed branches.
- Re-create worktrees any time with `bash scripts/setup-worktrees.sh`; open the four agent windows with
  `bash scripts/spawn-agents.sh`.

## Non-negotiables
- **No Mojang/Microsoft assets or code.** No textures, sounds, fonts, models or names copied from Minecraft.
  Original art and audio only. Generic block names (stone, dirt, oak) are fine; Minecraft-specific names are not.
- TypeScript `strict`. No `any`. Public API of a package is its `index.ts`; no deep imports across packages.
- `packages/{contracts,core,world,sim,net,storage}` must stay DOM-free (they run in Workers and Node).
- Tests travel with behaviour: Vitest for logic, Playwright for flows. `npm run check` green before merge.
- Deterministic worldgen: same seed, same chunks. Golden tests guard this.
- Secrets never enter the repo. There are none needed in v1.

## Gotchas
- The repo lives in the WSL filesystem at `~/projects/vibecraft` (ext4). It was started on the Windows Desktop,
  but on 2026-10-09 WSL processes could not create files anywhere on `C:` (directory creation worked, file creation
  did not, while `cmd.exe` could write — a Windows-side block, most likely antivirus ransomware protection). Keep
  the repo here: git and node are also far faster on ext4. From Windows, open
  `\\wsl$\Ubuntu\home\egoodman\projects\vibecraft`.
- If the repo is ever moved, run `git worktree repair` afterwards so the worktrees find `.git` again.
- `.worktrees/` is gitignored on purpose. Do not commit it.
- `.remember/` is a local plugin history buffer, gitignored.
- The `--agent` flag replaces the default Claude Code system prompt with the agent file body. The agent bodies
  therefore restate the working rules they need.
