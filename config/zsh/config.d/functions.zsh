# Strip comments and empty lines out of a file
function catnc() {
  grep -E -v '(^#|^/)' "$1" | sed '/^$/d' | bat -p --pager=never
}

function help() {
  "$@" --help 2>&1 | bathelp
}

