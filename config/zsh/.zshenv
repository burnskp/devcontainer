#!/bin/zsh
umask 022

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

if ! [ -d "$XDG_STATE_HOME/zsh" ]; then
  mkdir -p $XDG_STATE_HOME/zsh
fi

set -o noclobber
setopt nobeep
setopt completeinword
setopt correct
setopt extended_glob
setopt hash_list_all
setopt interactivecomments
setopt noflowcontrol
setopt nonomatch
setopt noshwordsplit
setopt prompt_subst

export BAT_THEME="Catppuccin Latte"
export GLAMOUR_STYLE="$HOME/.config/glamour/catppuccin-latte.json"
export EDITOR="nvim"
export LESS=-R
export PAGER="less -R"

export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export PYTHON_HISTORY="$XDG_DATA_HOME/share/python/history"

check_paths=()
check_paths+="${HOME}/.bun/bin"
check_paths+="${HOME}/.cargo/bin"
check_paths+="${HOME}/.local/bin"
check_paths+="${HOME}/.local/share/bun/bin"
check_paths+="${HOME}/.local/share/node/bin"
check_paths+="${HOME}/.local/share/nvim/mason/bin"
check_paths+="${HOME}/bin"
check_paths+="${XDG_DATA_HOME}/npm/bin"

for p in $check_paths; do
  if [[ -d "$p" ]]; then
    path+="$p"
  fi
done

typeset -U PATH
export PATH
