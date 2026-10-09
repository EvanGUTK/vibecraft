---
tags: [vibecraft, decisions, adr]
updated: 2026-10-09
---

# Decisions

Newest first. One entry per decision: date, decision, why, alternatives considered. Reversing a decision is a new
entry that links the old one. See [[architecture]] for the design these decisions produce.

## 2026-10-09 — ADR-013: Repo lives in the WSL filesystem, not on `/mnt/c`
**Decision.** The repo and all worktrees live at `~/projects/vibecraft` (ext4 inside WSL). Windows reaches it at
`\\wsl$\Ubuntu\home\egoodman\projects\vibecraft`.
**Why.** On 2026-10-09 WSL processes could not create files anywhere on `C:` (directory creation worked, file
creation returned EACCES, `cmd.exe` could write the same path, and WSL had written to a sibling repo the day
before). That points to Windows-side antivirus/ransomware protection blocking WSL's file server. Separately, git
and node are several times faster on ext4 than over the 9p mount.
**Alternatives.** Fix the Windows policy and keep the repo on the Desktop (user's call; `mv` + `git worktree
repair` moves it back); a non-Desktop `C:` path (also blocked in the probe).

## 2026-10-09 — ADR-012: Agents coordinate through git worktrees and board files, not chat
**Decision.** Four Claude Code sessions run in four worktrees on four branches. The shared channel is git plus
`docs/notes/todo.md` (board) and `docs/notes/handoffs/`. Chief is the only one who merges into `integration`.
**Why.** Separate CLI windows cannot message each other; git and files are durable, reviewable and survive
restarts. One integrator prevents merge races and keeps the architecture coherent.
**Alternatives.** A single session with subagents (less parallelism, one context window); a shared remote with
PRs (adds GitHub setup the user has not asked for yet). Protocol in [[agent-protocol]].

## 2026-10-09 — ADR-011: Audio ships as Ogg Vorbis primary with AAC fallback
**Decision.** `tools/sound` encodes every WAV master to `.ogg` (Vorbis q5) and `.m4a` (AAC). The engine picks by
`canPlayType`/`decodeAudioData` support.
**Why.** Vorbis loops gaplessly and is small; AAC covers Safari versions without Vorbis. MP3 was rejected for
loop gaps and encoder padding. Opus-in-WebM was rejected for Safari inconsistency in 2026.
**Alternatives.** Opus only; MP3 only; raw WAV (too large for a PWA precache).

## 2026-10-09 — ADR-010: Original assets only, no Mojang/Microsoft content
**Decision.** No textures, sounds, music, fonts, models, skins, names or code from Minecraft, including edited or
"recreated" copies. Visual Arts Master and Sound Master create from scratch or use CC0 with provenance recorded in
`assets/*/LICENSES.md`. "Minecraft" never appears in product UI.
**Why.** Copyright and trademark. The project's whole value is being freely playable at a URL; a takedown ends
that. It is also why two of the four agents exist.
**Alternatives.** Community resource packs (licensing is inconsistent); "placeholder" Mojang assets during dev
(they always leak into releases). Rejected.

## 2026-10-09 — ADR-009: Preact + signals for the DOM UI layer
**Decision.** `packages/ui` uses Preact with `@preact/signals` for HUD and screens, rendered as a DOM overlay above
the WebGL canvas.
**Why.** 4 KB, React-compatible mental model the agents know, signals give cheap fine-grained HUD updates at 60 FPS
without re-rendering trees. DOM gives accessibility and text rendering for free.
**Alternatives.** React (heavier, no benefit); vanilla TS (more boilerplate for ~12 screens); canvas-drawn UI
(loses accessibility and font rendering).

## 2026-10-09 — ADR-008: PWA via vite-plugin-pwa (Workbox)
**Decision.** Service worker precaches shell + engine + content + small sounds; runtime caches music and landing art.
Update flow is "wait, then prompt from the pause menu".
**Why.** "Works offline" is a v1 requirement (§1.1). Workbox handles precache manifests and cache busting with the
Vite build graph.
**Alternatives.** Hand-written service worker (more control, more bugs); no offline (fails the product promise).

## 2026-10-09 — ADR-007: IndexedDB per world; `.vcw` zip for export/import
**Decision.** One IndexedDB database per world with `meta`, `chunks`, `players` stores; a global index DB for the
landing; `.vcw` zip (fflate) for export/import; `navigator.storage.persist()` requested on first save.
**Why.** IndexedDB is the only large, structured, worker-accessible storage in browsers. A zip is inspectable and
portable. Per-world databases make delete and export trivial.
**Alternatives.** OPFS (good, but Safari/Firefox worker support uneven in 2026; candidate for v2 chunk files);
localStorage (far too small).

## 2026-10-09 — ADR-006: Hand-written binary protocol codec
**Decision.** Packets are `u8 id + varint length + payload` over `DataView`, defined in `contracts/protocol`.
Chunk payloads reuse the save codec bytes.
**Why.** Chunk and entity traffic is hot; a schema compiler (protobuf/flatbuffers) adds build steps and bundle
weight for a protocol we fully control. Reusing the save encoding means zero re-encoding on the server.
**Alternatives.** JSON (10× bytes, slow for chunks); MessagePack (fine, but still generic); protobuf (tooling).

## 2026-10-09 — ADR-005: Integrated server in a Worker; one protocol for local and remote
**Decision.** Singleplayer runs the authoritative `sim` in a Web Worker behind `LocalTransport`. Multiplayer swaps
in `WebSocketTransport` to `apps/server`. Client code is identical.
**Why.** One gameplay code path, smooth main thread, saves consistent, multiplayer becomes a transport swap. This
is the design Minecraft itself converged on.
**Alternatives.** Sim on the main thread (simpler, janky, and multiplayer becomes a rewrite). Rejected.

## 2026-10-09 — ADR-004: Custom WebGL2 renderer with texture arrays; Three.js rejected
**Decision.** `packages/renderer` is a thin WebGL2 layer behind a `Renderer` interface; block tiles live in a
`TEXTURE_2D_ARRAY`. WebGPU backend later behind the same interface.
**Why.** Voxel rendering is a few specialised passes with packed vertex formats and worker-built meshes; a
general scene graph adds overhead and fights those optimisations. Texture arrays remove atlas bleeding and give
correct mipmaps per tile.
**Alternatives.** Three.js (fast start, but custom geometry/materials everywhere anyway); Babylon (heavier);
WebGPU-first (Safari/Firefox coverage still uneven on older machines in 2026).

## 2026-10-09 — ADR-003: 16³ sections, world height 256 in v1
**Decision.** Columns are 16 × 256 × 16 as 16 sections of 16³. Height is a world constant read from `Welcome`, so
384 (y −64..320) is a later config change plus a save migration.
**Why.** Keeps indices, lighting and meshing simple; 256 is plenty for v1 gameplay.
**Alternatives.** 384 now (more memory and gen time per column for no v1 benefit); cubic chunks (complex
streaming).

## 2026-10-09 — ADR-002: TypeScript strict, npm workspaces, Vite, Vitest, Playwright
**Decision.** Single language across engine, apps, tools and MCP server. npm 11 workspaces (already installed), Vite
for the web app, `tsx` for Node, Vitest for unit tests, Playwright for e2e/perf, ESLint + Prettier.
**Why.** One toolchain the four agents share; TypeScript runs in Workers, Node and the browser; the user's machine
has Node 24 + npm 11 and no Java/pnpm.
**Alternatives.** Rust + wasm engine (performance headroom, but slows iteration and splits the team's language);
pnpm (not installed; would need a global install).

## 2026-10-09 — ADR-001: Product definition
**Decision.** VibeCraft is a browser-native, offline-first voxel sandbox in the spirit of Minecraft: no account, no
download, works offline, original assets. It is not a Minecraft client and does not speak the Minecraft protocol.
**Why.** The user's reference is vel.gg/bo1z (a free, no-download browser port of Black Ops 1 Zombies). The
sentence "like that but for offline Minecraft" reads most naturally as the same promise for a Minecraft-style
game. Protocol compatibility would be a different, legally harder project.
**Alternatives.** A viewer for real Minecraft save files; an offline-mode server launcher. Both noted in
[[architecture]] §16 for the user to overrule.
