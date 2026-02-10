# Strip comments and empty lines out of a file
catnc() {
  grep -E -v '(^#|^/)' "$1" | sed '/^$/d' | bat -p --pager=never
}

help() {
  "$@" --help 2>&1 | bathelp
}

agent() {
  opencode "$@"
}

