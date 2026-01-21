#!/bin/zsh

# basic git aliases
alias ga="git add"
alias gac="git commit -a"
alias gacm="git commit -a -m"
alias gacp="git commit -a && git push origin HEAD"
alias gap="git add -p"
alias gb="git branch"
alias gbl="git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)'"
alias gc="git commit -v"
alias gcam="git commit --amend"
alias gcb="git checkout -b"
alias gch="git checkout"
alias gcl="git clone"
alias gcm="git commit -m"
alias gcp="git commit && git push origin HEAD"
alias gd="git diff --color-moved"
alias gdm="git diff --color-moved origin/main"
alias gds="git diff --color-moved --staged"
alias gdt="git difftool"
alias gl="git log --graph --decorate"
alias gld="git log --all --graph --decorate --oneline --simplify-by-decoration"
alias glg="git log --graph --pretty=format:'%C(auto)%h -%d %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glf='git log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --decorate --numstat'
alias glp="git log -p --decorate"
alias gls="git log --date=short --format='%C(yellow)%h %C(cyan)%ad %C(reset)%s'"
alias gmt="nvim -c DiffviewOpen"
alias gmv="git mv"
alias gp='git push origin HEAD'
alias gpf='git push --force-with-lease origin HEAD'
alias gpo='git push origin'
alias gpub='git pull --rebase=merges --prune origin'
alias grm="git rm"
alias grb="git rebase"
alias grh="git reset HEAD"
alias gs="git status -s"
alias gst="git status"
alias gundo="git reset HEAD~1 --soft"

# git functions
gacmp() {
  git commit -a -m "$*" && git push origin HEAD
}

gcmp() {
  git commit -m "$*" && git push origin HEAD
}

gm() {
  local currentBranch
  if currentBranch=$(git symbolic-ref --short -q HEAD); then
    git checkout "$1" && \
      git pull && \
      git checkout "$currentBranch" && \
      git rebase "$1"
  else
    echo "Not on any branch"
    return 1
  fi
}

gss() {
  git stash || { echo "Stash failed"; return 1; }
  if ! git checkout "$1"; then
    echo "Checkout failed, restoring stash"
    git stash pop
    return 1
  fi
  if ! git stash pop; then
    echo "Warning: stash pop had conflicts, resolve manually"
    return 1
  fi
}

grbm() {
  local current
  current=$(git rev-parse --abbrev-ref HEAD)
  git fetch origin main && \
    git rebase origin/main
}

gu() {
  git fetch "$1" --prune
  git merge --ff-only "$1/$2" || git rebase --rebase=merges "$1/$2"
}

gsearch() {
  git rev-list --all | xargs git grep -F "$*"
}

gpu() {
  git pull origin "$(git rev-parse --abbrev-ref HEAD)"
}

gr() {
  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    cd "$(git rev-parse --show-toplevel)"
  else
    echo "Not in a git repo"
    return 1
  fi
}

fsb() {
  git fetch --prune
  local pattern=$*
  local branches branch
  branches=$(git branch --all | awk 'tolower($0) ~ /'"$pattern"'/') &&
    branch=$(echo "$branches" | fzf -p -1 -0 +m) &&
    if [[ -z "$branch" ]]; then
      echo "[$0] No branch matches the provided pattern"
      return 1
    fi
  git checkout "$(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")"
}

fshow() {
  git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort --preview \
      'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
      --header "enter to view, ctrl-o to checkout" \
      --bind "q:abort,ctrl-f:preview-page-down,ctrl-b:preview-page-up" \
      --bind "ctrl-o:become:(echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs git checkout)" \
      --bind "ctrl-m:execute:
(grep -o '[a-f0-9]\{7\}' | head -1 |
xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
      {}
FZF-EOF" --preview-window=right:60%
}

# worktree functions (stores worktrees in ~/worktree/BRANCH)
# assumes single repo under /work

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
    git -C "$repo_dir" worktree add "$worktree_dir" "$branch" && \
      cd "$worktree_dir" && claude --dangerously-skip-permissions
  fi
}

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

wtd() {
  local current_dir="$PWD"
  local worktree_base="$HOME/worktree"
  local repo_dir="/work/"*(/Y1)

  if [[ "$current_dir" != "$worktree_base"/* ]]; then
    echo "Error: Not in a worktree directory"
    return 1
  fi

  local branch="${current_dir#$worktree_base/}"
  branch="${branch%%/*}"

  cd "$repo_dir" && \
    git worktree remove "$worktree_base/$branch" && \
    git branch -D "$branch"
}

wtl() {
  local repo_dir="/work/"*(/Y1)
  git -C "$repo_dir" worktree list
}

wtr() {
  local repo_dir="/work/"*(/Y1)
  cd "$repo_dir"
}

wtsync() {
  git fetch origin main && git rebase origin/main
}

wtclean() {
  local repo_dir="/work/"*(/Y1)
  local worktree_base="$HOME/worktree"

  git -C "$repo_dir" fetch origin main

  for dir in "$worktree_base"/*(N/); do
    local branch="${dir:t}"
    if git -C "$repo_dir" branch --merged origin/main | grep -q "^\s*$branch$"; then
      echo "Removing merged worktree: $branch"
      git -C "$repo_dir" worktree remove "$dir" && \
        git -C "$repo_dir" branch -d "$branch"
    fi
  done
}

# tab completion for worktree commands
_wt_complete() {
  local repo_dir="/work/"*(/NY1)
  local branches
  branches=(${(f)"$(git -C "$repo_dir" branch --format='%(refname:short)' 2>/dev/null)"})
  _describe 'branch' branches
}

_wts_complete() {
  local worktrees=("$HOME/worktree"/*(N/:t))
  _describe 'worktree' worktrees
}

compdef _wt_complete wt
compdef _wts_complete wts wtd
