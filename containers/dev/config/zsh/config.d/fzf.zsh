#!/bin/zsh
if [[ $commands[fzf] ]]; then
  source <(fzf --zsh)
  export FZF_DEFAULT_OPTS="--style full --ansi --no-scrollbar \
--color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
--color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
--color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
--color=selected-bg:#BCC0CC --color=border:#CCD0DA,label:#4C4F69 \
--color=gutter:-1 --tmux"
  alias fp="fzf --ansi --style full --preview 'bat --color=always --style=plain {}' --no-scrollbar"
  alias zp=alias zp='cd ~/projects/$(fd . -t d --maxdepth 1 ~/projects --exec basename | fzf)'

  function gpr() {
    fzf --ansi \
      --border vertical --info inline --header-lines 4 \
      --preview 'GH_FORCE_TTY=$FZF_PREVIEW_COLUMNS gh pr view --comments {1}' \
      --preview-window up:border-down \
      --with-shell 'bash -c' \
      --bind 'start:preview(echo Loading pull requests ...)+reload:GH_FORCE_TTY=$((FZF_COLUMNS-3)) gh pr list --limit=1000' \
      --bind 'load:transform:(( FZF_TOTAL_COUNT )) || echo become:echo No pull requests' \
      --bind 'ctrl-o:execute-silent:gh pr view --web {1}' \
      --bind 'enter:become:gh pr checkout {1}' "$@"
  }

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

  function zg() {
    dir="$HOME/git"
    list=$(fd -t d -H -I '^\.git$' --base-directory "$dir" | sed -e 's|/.git/||' -e "s,/,: ," | sort -u)
    if [[ $# -eq 1 ]]; then
      selected=$(echo "$list" | fzf -1 -q "$1")
    else
      selected=$(echo "$list" | fzf)
    fi

    if [[ $selected ]]; then
      cd "$dir/$(echo $selected | sed -e "s,: ,/,")"
    fi
  }

  function zp() {
    dir="$HOME/projects"
    list=$(fd -t d -H -d 1 --base-directory "$dir" | sort -u | sed 's:/$::')
    if [[ $# -eq 1 ]]; then
      selected=$(echo "$list" | fzf -1 -q "$1")
    else
      selected=$(echo "$list" | fzf)
    fi

    if [[ $selected ]]; then
      cd "$dir/$selected"
    fi
  }
fi
