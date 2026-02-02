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
alias gcb="git switch"
alias gch="git checkout"
alias gcl="git clone"
alias gcm="git commit -m"
alias gcp="git commit && git push origin HEAD"
alias gd="git diff --color-moved"
alias gdm="git diff --color-moved origin/main"
alias gds="git diff --color-moved --staged"
alias gdt="git difftool"
alias gf="git fetch"
alias gfa="git fetch --all --prune"
alias gl="git log --graph --decorate"
alias gld="git log --all --graph --decorate --oneline --simplify-by-decoration"
alias glf='git log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --decorate --numstat'
alias glg="git log --graph --pretty=format:'%C(auto)%h -%d %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glp="git log -p --decorate"
alias gls="git log --date=short --format='%C(yellow)%h %C(cyan)%ad %C(reset)%s'"
alias gmt="nvim -c DiffviewOpen"
alias gmv="git mv"
alias gnb="git switch -c"
alias gp='git push origin HEAD'
alias gpf='git push --force-with-lease origin HEAD'
alias gpo='git push origin'
alias gpub='git pull --rebase=merges --prune'
alias gra="git rebase --abort"
alias grb="git rebase"
alias grc="git rebase --continue"
alias grh="git reset HEAD"
alias grm="git rm"
alias gs="git status -s"
alias gst="git status"
alias gsta="git stash push"
alias gstp="git stash pop"
alias gundo="git reset HEAD~1 --soft"
alias gstl="git stash list"

gwip() {
  git add -A && git commit -m "WIP: ${*:-work in progress}" --no-verify
}

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
    git fetch origin "$1" && \
      git switch "$currentBranch" && \
      git rebase --rebase-merges origin/"$1"
  else
    echo "Not on any branch"
    return 1
  fi
}

gss() {
  local stashed=0
  if ! git diff --quiet || ! git diff --cached --quiet; then
    git stash push || { echo "Stash failed"; return 1; }
    stashed=1
  fi
  if ! git switch "$1"; then
    echo "Switch failed"
    [[ $stashed -eq 1 ]] && git stash pop
    return 1
  fi
  if [[ $stashed -eq 1 ]]; then
    if ! git stash pop; then
      echo "Warning: stash pop had conflicts, resolve manually"
      return 1
    fi
  fi
}

grbm() {
  git fetch origin main && git rebase --rebase-merges origin/main
}

gu() {
  git fetch "$1" --prune
  git merge --ff-only "$1/$2" || git rebase --rebase-merges "$1/$2"
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
    branch=$(echo "$branches" | fzf -1 -0 +m) &&
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
      'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7,\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
      --header "enter to view, ctrl-o to checkout" \
      --bind "q:abort,ctrl-f:preview-page-down,ctrl-b:preview-page-up" \
      --bind "ctrl-o:become:(echo {} | grep -o '[a-f0-9]\{7,\}' | head -1 | xargs git checkout)" \
      --bind "ctrl-m:execute:
(grep -o '[a-f0-9]\{7,\}' | head -1 |
xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
      {}
FZF-EOF" --preview-window=right:60%
}
