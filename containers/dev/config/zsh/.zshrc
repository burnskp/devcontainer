#!/bin/zsh
eval "$(starship init zsh)"

for i in $XDG_CONFIG_HOME/zsh/config.d/*.zsh; do
  source "$i"
done

ZAQ_PREFIXES=('git commit -m' 'gcm' 'gcmp' 'gacmp' 'chezmoi git commit -m' 'chgcm' 'chgacmp' 'chgcmp' 'ssh( -[^ ]##)# [^ -][^ ]#' 'sshnh( -[^ ]##)# [^ -][^ ]#')

zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

typeset -U PATH
