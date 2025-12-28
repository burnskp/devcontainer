#!/bin/zsh
# Strip comments and empty lines out of a file
function catnc() {
  grep -E -v '(^#|^/)' "$1" | sed '/^$/d' | bat -p --pager=never
}

function cdgb() {
  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    cd $(git rev-parse --show-toplevel)
  else
    echo "Not in a git repo."
  fi
}
