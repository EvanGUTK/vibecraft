---
tags: [vibecraft, process, agents]
updated: 2026-10-09
---

# Agent protocol

How the four agents (Chief, Code Master, Visual Arts Master, Sound Master) work in parallel on one repo without
stepping on each other. Each runs as its own Claude Code session (`claude --agent <name>`) in its own git
worktree. Design in [[architecture]] §14; decision in [[decisions]] ADR-012.

## 1. Topology

| Agent | Worktree | Branch | Role |
|---|---|---|---|
| Chief | `.worktrees/chief` | `integration` | architect, integrator, reviewer, board keeper, user's point of contact |
| Code Master | `.worktrees/code-master` | `agent/code-master` | all engine, app, network, storage, renderer, UI and tool code |
| Visual Arts Master | `.worktrees/visual-arts-master` | `agent/visual-arts-master` | all art, models, UI art, landing art, art pipeline |
| Sound Master | `.worktrees/sound-master` | `agent/sound-master` | audio engine, SFX, music, ambience, sound events, sound pipeline |

- `main` is protected. Only the **user** promotes `integration` → `main` (fast-forward) when a milestone exits.
- All worktrees share one `.git`. `git merge integration` is how an agent receives everyone else's merged work.
  Agents never merge each other's branches directly.
- The private GitHub repo `EvanGUTK/vibecraft` is the backup and the way to move between machines (ADR-014). Only
  the user pushes. No pull requests and no CI yet.
- Ownership by path is in `CLAUDE.md`. An agent edits only its own paths. Everything else is a **request** (§4).

## 2. Session routine (every agent, every session)

**Start**
```bash
git status --short && git branch --show-current          # expect your own branch, clean tree
git merge --no-edit integration                           # pick up merged work (Chief skips this)
cat docs/notes/todo.md                                    # the board
ls -t docs/notes/handoffs | head                          # anything new addressed to you
```
Then: pick the top `[~]` item of yours, or the top `[ ]` if none, mark it `[~]`, and state a short plan to the
user before writing code. Non-trivial = wait for a go.

**Work**: small commits on your branch (`type: what and why`), tests with behaviour, `npm run check` green before
you consider anything done. Never commit to `integration` or `main` (Chief excepted for `integration`).

**End**: commit, move board items (`[~]` → `[r]` when ready for Chief), write a handoff (§3), tell the user in a
few lines what changed, how you verified it, what is open.

## 3. Handoffs

`docs/notes/handoffs/YYYY-MM-DD-<from>-to-<to>.md` (to = `chief`, `code-master`, `visual-arts-master`,
`sound-master`, `user`, or `all`). Keep it under a screen:

```markdown
---
from: code-master
to: chief
date: 2026-10-16
status: ready-for-review | request | fyi | blocked
---
## What
Branch `agent/code-master` at <short sha>: hello-chunk renders with texture array; fly camera.
## Verify
`npm run check` green (42 tests). `npm run dev` → http://localhost:5173/play.html?dev=1 shows a textured chunk.
## Needs from you
Merge into integration. Decide ADR on vertex packing if you disagree with 8-byte format.
## Open
Perf overlay numbers are placeholders until M1.
```

A handoff is the unit of communication. Chat with the user is for decisions; files are for the record.

## 4. Requests across ownership lines

Need a change in someone else's paths? Write a handoff with `status: request` naming the exact file(s), the
change, and why. Examples: Sound Master needs a new field in `contracts/schemas/sound-events.schema.json`
(→ Chief); Visual Arts needs the renderer to read a `lightmap.png` (→ Code Master); Code Master needs a sound
event id for block placement (→ Sound Master). The owner implements, replies with a handoff, and the board item
moves. Do not "just fix it" in another agent's directory, even if it is one line.

Shared **contracts** (`packages/contracts`) change only through Chief with an ADR line in [[decisions]].

## 5. Review and merge (Chief)

For each `[r]` item:
```bash
git log --oneline integration..agent/<name>
git diff --stat integration...agent/<name>
git diff integration...agent/<name> -- <paths of interest>
```
Checklist (architecture §13.5): check green, tests present, boundaries respected, assets validated + LICENSES
updated, docs updated, perf not regressed, ownership respected. Then
```bash
git merge --no-ff agent/<name> -m "merge: agent/<name> — <summary>"
npm run check
```
Update the board (`[r]` → `[x] (date)`), write a short handoff to `all` summarising what landed, and report to
the user. If review fails: handoff to the author with `status: request` listing exact problems; do not fix it
yourself.

Conflicts: the author resolves in their worktree (`git merge integration`, fix, test, re-request). Chief never
resolves content conflicts in someone else's area.

## 6. Delegation

Chief may also use the Agent tool to spawn `code-master`, `visual-arts-master` or `sound-master` as subagents for
bounded tasks (e.g. "review this diff for renderer regressions"). Those subagents work in Chief's worktree and
must not commit; Chief commits. The long-running agent windows remain the primary way work happens.

## 7. Definition of done (any item)

Works in the browser or in tests as described; `npm run check` green; tests added for new behaviour; docs touched
if design changed; board updated; handoff written; nothing outside your ownership modified.

## 8. Escalation to the user

Ask the user (not Chief) when: a decision changes scope or cannot be undone; a legal/licensing question arises; a
default in [[architecture]] §16 looks wrong; two agents disagree and Chief cannot settle it with an ADR.

## 9. Status report format (to the user)

Three to six lines: what changed, how it was verified (command + result), what is open or blocked, what you will
do next. Lead with the result. No praise, no filler.
