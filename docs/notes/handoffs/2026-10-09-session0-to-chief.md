---
from: setup-session
to: chief
date: 2026-10-09
status: kickoff
---
## What exists (all on `main` and `integration`)
- Architecture (`architecture.md`, 16 sections), 14 ADRs, the board, agent protocol, seed notes for art direction
  and sound design, repo `CLAUDE.md`.
- Four agents in `.claude/agents/`, four branches (`integration`, `agent/code-master`,
  `agent/visual-arts-master`, `agent/sound-master`), scripts to rebuild the worktrees and open the windows.
- Private GitHub repo `EvanGUTK/vibecraft` holds all of it.

## What is NOT done
- No product code, no `package.json`, no `npm run check` yet. Do not expect the commands in `CLAUDE.md` to work.
- Gate 0 is open: the user has not confirmed the ten defaults in `architecture.md` §16.
- Never verified: a real Windows Terminal launch from `spawn-agents.sh`, and the agents' `initialPrompt`
  behaviour in an interactive window. A print-mode load of the `chief` agent worked. If either misbehaves, fix the
  script or the agent file and tell the user.

## Your first job
Run the **Kickoff** section of your instructions (`.claude/agents/chief.md`): confirm the worktrees exist, tell the
user to call all four agents with the exact commands, walk them through Gate 0 with your recommended answers,
then write the M0 kickoff handoffs and tell them to say "go" in the other three windows.

## Context you will not find in the repo
- The user's reference is `vel.gg/bo1z`, a free no-download browser port of Black Ops 1 Zombies. "Offline
  Minecraft" was interpreted as the same promise for a Minecraft-style game. That interpretation is §16 item 1.
  If it is wrong, stop and re-plan with the user before anything else.
- The user wants the four agents run in parallel in four windows, with you commanding the process. They want
  short, plain updates and to see things running on a port before anything is committed or merged.
- On the work machine, WSL could not create files on `C:` (ADR-013), so the repo was built at
  `~/projects/vibecraft`. On a new machine keep the clone on the Linux filesystem.
- Git identity is repo-local `egoodman <evanggoodman@gmail.com>`; no global identity was set.
- Main was committed to directly during setup, and fast-forwarded from `integration`. From now on only the user
  promotes `integration` to `main`.
