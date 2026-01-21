alias Grep="grep --color -i"
alias grep="grep --color -i"
alias nv="nvim"
alias sz="source $XDG_CONFIG_HOME/zsh/.zshrc"
alias va='source .venv/bin/activate'
alias vi="nvim"
alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"

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
