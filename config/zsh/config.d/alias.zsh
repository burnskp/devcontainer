#!/bin/zsh
alias ls="ls --color"
alias grep="grep --color -i"
alias Grep="grep --color -i"
alias sz="source $XDG_CONFIG_HOME/zsh/.zshrc"
alias va='source .venv/bin/activate'
alias vi="nvim"
alias nv="nvim"

alias bathelp='bat --plain --language=help'
alias bl="bat --paging=never -l log"
alias cat='bat -p --paging=never'
alias catl='bat --style header,snip,grid --pager=never'
alias catp='bat --style header,snip,grid'
alias diff="batdiff --delta"
alias man="batman"
alias pretty="prettybat"
alias rg="batgrep -S"
alias rgi="batgrep -i"
alias rgs="batgrep -s"
alias tf="tail -f | bat --paging=never -l log"

alias clauded="claude --allow-dangerously-skip-permissions"

function help() {
  "$@" --help 2>&1 | bathelp
}
