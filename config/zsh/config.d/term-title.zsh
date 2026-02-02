typeset -a excluded_commands
excluded_commands=('ls' 'cd' 'echo' 'pwd' 'git' 'cat' 'bat')

function title-precmd() {
  [[ -z $TMUX ]] && return
  local dir
  if [[ $PWD == "$HOME" ]]; then
    dir="~"
  else
    dir="${PWD##*/}"
  fi
  [[ ${#dir} -gt 30 ]] && dir="${dir:0:27}..."
  print -n "\ekd:${dir}\e\\"
}

function title-preexec() {
  [[ -z $TMUX ]] && return
  cmd_name="${1%% *}"
  if [[ ! ${excluded_commands[(r)$cmd_name]} ]]; then
    [[ ${#cmd_name} -gt 30 ]] && cmd_name="${cmd_name:0:27}..."
    print -n "\ek${cmd_name}\e\\"
  fi
}

autoload -Uz add-zsh-hook

add-zsh-hook -Uz precmd title-precmd
add-zsh-hook -Uz preexec title-preexec
