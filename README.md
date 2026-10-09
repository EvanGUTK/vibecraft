# VibeCraft

A browser-native, offline-first voxel sandbox in the spirit of Minecraft. Open a URL, pick a world, play.
No download, no account, no server. Works offline after the first visit. All art and sound are original.

Reference point: [vel.gg/bo1z](https://vel.gg/bo1z) does this for Black Ops 1 Zombies. VibeCraft does it for a
Minecraft-style game.

- Architecture: [docs/notes/architecture.md](docs/notes/architecture.md)
- Decisions (ADRs): [docs/notes/decisions.md](docs/notes/decisions.md)
- Board: [docs/notes/todo.md](docs/notes/todo.md)
- How the four agents work together: [docs/notes/agent-protocol.md](docs/notes/agent-protocol.md)

Status: architecture phase. No product code yet. M0 scaffold begins after the architecture is approved.

## Clone and start (any machine with WSL, Node 24 and Claude Code)
```bash
git clone https://github.com/EvanGUTK/vibecraft.git ~/projects/vibecraft   # keep it on the Linux filesystem
cd ~/projects/vibecraft
bash scripts/setup-worktrees.sh     # rebuilds the four agent worktrees from the pushed branches
bash scripts/spawn-agents.sh        # opens Chief, Code Master, Visual Arts, Sound Master in Windows Terminal
```
Chief opens first-session instructions from `docs/notes/handoffs/2026-10-09-session0-to-chief.md` and walks you
through the rest. Without Windows Terminal, open four terminals and run `cd .worktrees/<name> && claude --agent <name>`
for `chief`, `code-master`, `visual-arts-master`, `sound-master`.
