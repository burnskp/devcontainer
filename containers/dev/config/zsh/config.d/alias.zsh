#!/bin/zsh
# global dot aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

alias grep="grep --color -i"
alias Grep="grep --color -i"
alias sz="source $XDG_CONFIG_HOME/zsh/.zshrc"
alias va='source .venv/bin/activate'
alias vi="nvim"

if [ $commands[batcat] ]; then
  alias bat=batcat
fi

alias bathelp='batcat --plain --language=help'
alias bl="batcat --paging=never -l log"
alias cat='batcat -p --paging=never'
alias catl='batcat --style header,snip,grid --pager=never'
alias catp='batcat --style header,snip,grid'
alias diff="batdiff --delta"
alias man="batman"
alias pretty="prettybat"
alias rg="batgrep -S"
alias rgi="batgrep -i"
alias rgs="batgrep -s"
alias tf="tail -f | bat --paging=never -l log"

function help() {
  "$@" --help 2>&1 | bathelp
}

alias la="eza -a --no-time --no-user --git --group-directories-first"
alias ld="eza -D --no-time --no-user --git --group-directories-first"
alias ldl="eza -lFD --no-time --no-user --git --group-directories-first"
alias le="eza -lF --extended --no-time --no-user --git --group-directories-first"
alias ll="eza -lF --no-time --no-user --git --group-directories-first"
alias lla="eza --lFa --no-time --no-user --git --group-directories-first"
alias ls="eza --no-time --no-user --git --group-directories-first"
alias lsize="eza -lF --no-time --no-user --git --group-directories-first --sort=size"
alias lt="eza -lF --no-user --git --group-directories-first"
alias lu="eza -glF --git --group-directories-first"
