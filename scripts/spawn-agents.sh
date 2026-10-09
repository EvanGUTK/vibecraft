#!/usr/bin/env bash
# Open the four VibeCraft agents in one Windows Terminal window (four tabs), each in its own worktree,
# each running `claude --agent <name>`. Run from WSL. Re-running adds tabs to the same window.
#
#   bash scripts/spawn-agents.sh                 # open all four
#   bash scripts/spawn-agents.sh --dry-run       # print the wt.exe command only
#   bash scripts/spawn-agents.sh -- --permission-mode acceptEdits   # extra args passed to every claude
#   AGENTS="chief code-master" bash scripts/spawn-agents.sh         # subset
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DISTRO="${WSL_DISTRO_NAME:-Ubuntu}"
WINDOW="${WT_WINDOW:-vibecraft}"
AGENTS="${AGENTS:-chief code-master visual-arts-master sound-master}"

DRY_RUN=0
CLAUDE_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --) shift; CLAUDE_ARGS=("$@"); break ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

title_for() {
  case "$1" in
    chief) echo "Chief" ;;
    code-master) echo "Code Master" ;;
    visual-arts-master) echo "Visual Arts" ;;
    sound-master) echo "Sound Master" ;;
    *) echo "$1" ;;
  esac
}

command -v wt.exe >/dev/null || { echo "error: wt.exe (Windows Terminal) not found on PATH" >&2; exit 1; }

cmd=(wt.exe -w "$WINDOW")
first=1
for agent in $AGENTS; do
  wt_dir="$REPO/.worktrees/$agent"
  [[ -d "$wt_dir" ]] || { echo "error: missing worktree $wt_dir (run scripts/setup-worktrees.sh)" >&2; exit 1; }
  # Inside the tab: login+interactive bash so PATH (~/.local/bin, nvm) loads; keep the shell open after claude exits.
  inner="claude --agent $agent"
  for a in "${CLAUDE_ARGS[@]+"${CLAUDE_ARGS[@]}"}"; do inner+=" $(printf '%q' "$a")"; done
  inner+="; exec bash"
  [[ $first -eq 1 ]] || cmd+=(";")
  first=0
  cmd+=(new-tab --title "$(title_for "$agent")" --suppressApplicationTitle
        wsl.exe -d "$DISTRO" --cd "$wt_dir" -- bash -lic "$inner")
done

if [[ $DRY_RUN -eq 1 ]]; then
  printf '%q ' "${cmd[@]}"; echo
  exit 0
fi

"${cmd[@]}"
echo "opened ${AGENTS// /, } in Windows Terminal window '$WINDOW'"
