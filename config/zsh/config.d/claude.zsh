#!/bin/zsh
alias clauded="claude --dangerously-skip-permissions"

wt() {
  local branch="$1"
  local repo_dir="/work/"*(/Y1)
  local worktree_dir="$HOME/worktree/$branch"

  if [[ -z "$branch" ]]; then
    echo "Usage: wt <branch-name>"
    return 1
  fi

  if [[ ! -d "$repo_dir/.git" ]]; then
    echo "Error: No git repository found under /work"
    return 1
  fi

  if [[ -d "$worktree_dir" ]]; then
    cd "$worktree_dir" && claude --dangerously-skip-permissions
  else
    mkdir -p "$HOME/worktree"
    git -C "$repo_dir" worktree add "$worktree_dir" "$branch" && cd "$worktree_dir" && claude --dangerously-skip-permissions
  fi
}

wtd() {
  local current_dir="$PWD"
  local worktree_base="$HOME/worktree"
  local repo_dir="/work/"*(/Y1)

  if [[ "$current_dir" != "$worktree_base"/* ]]; then
    echo "Error: Not in a worktree directory"
    return 1
  fi

  local branch="${current_dir#$worktree_base/}"
  branch="${branch%%/*}"  # Get just the branch name if in a subdirectory

  cd "$repo_dir" && \
    git worktree remove "$worktree_base/$branch" && \
    git branch -D "$branch"
}

# List all worktrees
wtl() {
  local repo_dir="/work/"*(/Y1)
  git -C "$repo_dir" worktree list
}

# Switch to an existing worktree (with tab completion)
wts() {
  local branch="$1"
  local worktree_dir="$HOME/worktree/$branch"

  if [[ -z "$branch" ]]; then
    echo "Available worktrees:"
    ls "$HOME/worktree" 2>/dev/null || echo "  (none)"
    return 1
  fi

  if [[ -d "$worktree_dir" ]]; then
    cd "$worktree_dir"
  else
    echo "Worktree '$branch' not found"
    return 1
  fi
}

# Create worktree for a NEW branch (branched from main)
wtb() {
  local branch="$1"
  local repo_dir="/work/"*(/Y1)
  local worktree_dir="$HOME/worktree/$branch"

  if [[ -z "$branch" ]]; then
    echo "Usage: wtb <new-branch-name>"
    return 1
  fi

  mkdir -p "$HOME/worktree"
  git -C "$repo_dir" fetch origin main && \
    git -C "$repo_dir" worktree add -b "$branch" "$worktree_dir" origin/main && \
    cd "$worktree_dir" && claude --dangerously-skip-permissions
}

# Push current branch and open PR
wtpr() {
  local current_dir="$PWD"
  local worktree_base="$HOME/worktree"
  local repo_dir="/work/"*(/Y1)

  if [[ "$current_dir" != "$worktree_base"/* ]]; then
    echo "Error: Not in a worktree directory"
    return 1
  fi

  local branch="${current_dir#$worktree_base/}"
  branch="${branch%%/*}"

  git push -u origin "$branch" && gh pr create --web
}

# Sync current worktree with main
wtsync() {
  git fetch origin main && git rebase origin/main
}

# Return to main repo
wtr() {
  local repo_dir="/work/"*(/Y1)
  cd "$repo_dir"
}

# Clean up merged worktrees
wtclean() {
  local repo_dir="/work/"*(/Y1)
  local worktree_base="$HOME/worktree"

  git -C "$repo_dir" fetch origin main

  for dir in "$worktree_base"/*(N/); do
    local branch="${dir:t}"
    if git -C "$repo_dir" branch --merged origin/main | grep -q "^\s*$branch$"; then
      echo "Removing merged worktree: $branch"
      git -C "$repo_dir" worktree remove "$dir" && git -C "$repo_dir" branch -d "$branch"
    fi
  done
}

# Tab completion for wts
_wts_complete() {
  local worktrees=("$HOME/worktree"/*(N/:t))
  _describe 'worktree' worktrees
}
compdef _wts_complete wts
