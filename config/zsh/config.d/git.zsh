#!/bin/zsh

# GitHub CLI
alias ghb="gh browse"
alias ghpr="gh pr create -f"
alias ghr='GH_PAGER="bat -p" gh run list --commit "$(git rev-parse HEAD)"'
alias gho="gh repo view -w"
alias ghw="gh run watch"
alias gfb="gh f -b"
alias gfg="gh f -g"
alias gfl="gh f -l"
alias gfk="gh f -k"
alias gfp="gh f -p"
alias gfr="gh f -r"
alias gft="gh f -t"

# basic git aliases
alias ga="git add"
alias gac="git commit -a"
alias gacm="git commit -a -m"
alias gacp="git commit -a && git push origin HEAD"
alias gap="git add -p"
alias gb="git branch"
alias gc="git commit -v"
alias gcam="git commit --amend"
alias gcb="git switch"
alias gch="git checkout"
alias gcl="git clone"
alias gcm="git commit -m"
alias gcp="git commit && git push origin HEAD"
alias gcr="git clean -fd"
alias gd="git diff --color-moved"
alias gdm="git diff --color-moved origin/main"
alias gds="git diff --color-moved --staged"
alias gf="git fetch --all --prune"
alias gl="git log --graph --decorate"
alias gld="git log --all --graph --decorate --oneline --simplify-by-decoration"
alias glf='git log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --decorate --numstat'
alias glg="git log --graph --pretty=format:'%C(auto)%h -%d %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glp="git log -p --decorate"
alias gls="git log --date=short --format='%C(yellow)%h %C(cyan)%ad %C(reset)%s'"
alias gmv="git mv"
alias gp='git push origin HEAD'
alias gpf='git push --force-with-lease origin HEAD'
alias gra="git rebase --abort"
alias grb="git rebase"
alias grc="git rebase --continue"
alias grh="git reset HEAD"
alias grm="git rm"
alias gs="git status -s"

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

gpu() {
  git pull origin "$(git rev-parse --abbrev-ref HEAD)"
}

gbd() {
  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    cd "$(git rev-parse --show-toplevel)"
  else
    echo "Not in a git repo"
    return 1
  fi
}
