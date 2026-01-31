#!/bin/zsh
WORKTREE_DIR="$HOME/worktree"

# Switch to existing worktree or create from existing branch, then open AI tool
wt() {
  local branch="$1"
  local repo_dir=(/work/*(/))
  local worktree_dir="$HOME/worktree/$branch"

  if [[ -z $branch ]]; then
    echo "Usage: wt <branch-name>"
    return 1
  fi

  if [[ ! -d "$repo_dir/.git" ]]; then
    echo "Error: No git repository found under /work"
    return 1
  fi

  if [[ -d $worktree_dir ]]; then
    echo "Switching to existing worktree for branch '$branch'"
    cd "$worktree_dir" && agent
  else
    echo "Creating new worktree for branch '$branch'"
    mkdir -p "$HOME/worktree"
    git -C "$repo_dir" worktree add "$worktree_dir" \
      && cd "$worktree_dir" \
      && agent
  fi
}

# Create worktree for a NEW branch (branched from main), then open AI tool
wtb() {
  local branch="$1"
  local repo_dir=(/work/*(/))
  local worktree_dir="$HOME/worktree/$branch"

  if [[ -z $branch ]]; then
    echo "Usage: wtb <new-branch-name>"
    return 1
  fi

  mkdir -p "$HOME/worktree"
  git -C "$repo_dir" fetch origin main \
    && git -C "$repo_dir" worktree add -b "$branch" "$worktree_dir" origin/main \
    && cd "$worktree_dir" \
    && agent
}

# Switch to an existing worktree (no AI tool)
wts() {
  local branch="$1"
  local worktree_dir="$HOME/worktree/$branch"

  if [[ -z $branch ]]; then
    echo "Available worktrees:"
    ls "$HOME/worktree" 2>/dev/null || echo "  (none)"
    return 1
  fi

  if [[ -d $worktree_dir ]]; then
    cd "$worktree_dir"
  else
    echo "Worktree '$branch' not found"
    return 1
  fi
}

# Delete worktree and its branch
wtd() {
  local worktree_base="$HOME/worktree"
  local repo_dir=(/work/*(/))
  local branch="$1"

  if [[ -z $branch ]]; then
    local current_dir="$PWD"
    if [[ $current_dir != "$worktree_base"/* ]]; then
      echo "Error: Not in a worktree directory"
      echo "Usage: wtd [branch-name]"
      return 1
    fi
    branch="${current_dir#$worktree_base/}"
    branch="${branch%%/*}"
    cd "$repo_dir"
  fi

  if [[ ! -d "$worktree_base/$branch" ]]; then
    echo "Error: Worktree '$branch' not found"
    return 1
  fi

  git -C "$repo_dir" worktree remove "$worktree_base/$branch" \
    && git -C "$repo_dir" branch -D "$branch"
}

# List all worktrees
wtl() {
  local repo_dir=(/work/*(/))
  git -C "$repo_dir" worktree list
}

# Return to main repo
wtr() {
  local repo_dir=(/work/*(/))
  cd "$repo_dir"
}

# Sync current worktree with main
wtsync() {
  git fetch origin main && git rebase origin/main
}

# Clean up merged worktrees
wtc() {
  local repo_dir=(/work/*(/))
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

# Tab completion
_wt_branches() {
  local repo_dir=(/work/*(/NY1))
  local branches
  branches=(${(f)"$(git -C "$repo_dir" branch --format='%(refname:short)' 2>/dev/null)"})
  _describe 'branch' branches
}

_wt_worktrees() {
  local worktrees=("$HOME/worktree"/*(N/:t))
  _describe 'worktree' worktrees
}

compdef _wt_branches wt
compdef _wt_worktrees wts wtd
