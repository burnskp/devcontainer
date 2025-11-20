#!/bin/zsh
eval "$(starship init zsh)"

for i in $XDG_CONFIG_HOME/zsh/config.d/*.zsh; do
  source "$i"
done

ZAQ_PREFIXES=('git commit -m' 'gcm' 'gcmp' 'gacmp' 'chezmoi git commit -m' 'chgcm' 'chgacmp' 'chgcmp' 'ssh( -[^ ]##)# [^ -][^ ]#' 'sshnh( -[^ ]##)# [^ -][^ ]#')

source "$XDG_CONFIG_HOME/zsh/plugins/autoquoter/zsh-autoquoter.zsh"
source "$XDG_CONFIG_HOME/zsh/plugins/autopair/autopair.zsh"
source "$XDG_CONFIG_HOME/zsh/plugins/history-substring-search/zsh-history-substring-search.zsh"

zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

source "$XDG_CONFIG_HOME/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "$XDG_CONFIG_HOME/zsh/plugins/you-should-use/you-should-use.plugin.zsh"

typeset -U PATH
