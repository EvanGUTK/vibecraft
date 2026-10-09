#!/usr/bin/env bash
# Create (or repair) the four agent worktrees. Idempotent: safe to re-run.
# Layout: .worktrees/<agent> on branch <branch>, all sharing this repo's .git. See docs/notes/agent-protocol.md.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO"

if ! git rev-parse --verify -q HEAD >/dev/null; then
  echo "error: the repo has no commits yet; worktrees need a base commit" >&2
  exit 1
fi

# agent name -> branch
declare -A BRANCH=(
  [chief]=integration
  [code-master]=agent/code-master
  [visual-arts-master]=agent/visual-arts-master
  [sound-master]=agent/sound-master
)
ORDER=(chief code-master visual-arts-master sound-master)

# The ignore pattern is directory-only (.worktrees/), so the directory must exist before check-ignore can match it.
mkdir -p .worktrees
git check-ignore -q .worktrees || { echo "error: .worktrees/ must be gitignored" >&2; exit 1; }

# New agent branches start from integration (the team baseline); main is the fallback on a fresh repo.
BASE=main
git show-ref --verify -q refs/heads/integration && BASE=integration

for agent in "${ORDER[@]}"; do
  branch="${BRANCH[$agent]}"
  path=".worktrees/$agent"
  if git worktree list --porcelain | grep -qx "worktree $REPO/$path"; then
    echo "ok      $path  ($branch) already exists"
    continue
  fi
  if git show-ref --verify -q "refs/heads/$branch"; then
    git worktree add "$path" "$branch" >/dev/null
  else
    git worktree add -b "$branch" "$path" "$BASE" >/dev/null
  fi
  echo "created $path  ($branch)"
done

echo
git worktree list
