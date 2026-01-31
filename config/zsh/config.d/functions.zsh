# Strip comments and empty lines out of a file
catnc() {
  grep -E -v '(^#|^/)' "$1" | sed '/^$/d' | bat -p --pager=never
}

help() {
  "$@" --help 2>&1 | bathelp
}

agent() {
  if [[ "$AI_AGENT" == "opencode" ]]; then
    opencode "$@"
  elif [[ "$AI_AGENT" == "claude" ]]; then
    claude --dangerously-skip-permissions "$@"
  else
    echo "Error: AI_AGENT environment variable is not set to a supported value."
    return 1
  fi
}

