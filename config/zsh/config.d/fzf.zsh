#!/bin/zsh
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--style full --ansi --no-scrollbar \
--color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
--color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
--color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
--color=selected-bg:#BCC0CC --color=border:#CCD0DA,label:#4C4F69 \
--color=gutter:-1 --tmux"

alias fp="fzf --ansi --style full --preview 'bat --color=always --style=plain {}' --no-scrollbar"

function gr() {
  local file
  file=$(git log --all --pretty=format: --name-only | sort -u | grep -v '^$' | fzf --prompt="Select file: ")
  [[ -z $file ]] && return
  local commit
  commit=$(git log --oneline -- $file | \
      fzf --preview "git show {1}:$file | bat --style=numbers --color=always --line-range :500 - 2>/dev/null || echo 'File deleted in this commit'" \
      --prompt="Select commit: " \
      --delimiter=' ' \
      --with-nth=1,2.. \
      --preview-window=up:60%:wrap \
    | awk '{print $1}')
  [[ $commit ]] && git checkout "$commit" -- "$file"
}
