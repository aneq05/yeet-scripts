#!/usr/bin/env bash

yeet_commit_main() {
  local command="${1:-format}"

  case "$command" in
    -h|--help|help)
      yeet_commit_usage
      ;;
    format)
      shift || true
      yeet_commit_format "$@"
      ;;
    types)
      printf '%s\n' feat fix docs style refactor test chore ci build perf revert
      ;;
    *)
      yeet_die "Usage: yeet commit format [type] [scope] <message...>"
      ;;
  esac
}

yeet_commit_usage() {
  cat <<'EOF'
Usage:
  yeet commit format [type] [scope] <message...>
  yeet commit types

Examples:
  yeet commit format feat auth add login validation
  yeet commit format fix cli handle missing project config
EOF
}

yeet_commit_format() {
  local type="${1:-}"
  [ -n "$type" ] || yeet_commit_interactive

  local can_have_scope=false
  if ! yeet_commit_valid_type "$type"; then
    type="chore"
  else
    can_have_scope=true
    shift || true
  fi

  local scope=""
  if [ "$can_have_scope" = "true" ] && [ "${1:-}" != "" ] && [ "$#" -gt 1 ]; then
    scope="$1"
    shift
  fi

  local message="$*"
  [ -n "$message" ] || yeet_die "Missing commit message"

  message="$(printf '%s' "$message" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g; s/[[:space:]]+/ /g')"
  local first="${message:0:1}"
  first="${first,,}"
  message="$first${message:1}"

  if [ -n "$scope" ]; then
    printf '%s(%s): %s\n' "$type" "$scope" "$message"
  else
    printf '%s: %s\n' "$type" "$message"
  fi
}

yeet_commit_valid_type() {
  case "$1" in
    feat|fix|docs|style|refactor|test|chore|ci|build|perf|revert) return 0 ;;
    *) return 1 ;;
  esac
}

yeet_commit_interactive() {
  local type scope message
  printf 'type [feat/fix/docs/style/refactor/test/chore/ci/build/perf/revert]: '
  read -r type
  yeet_commit_valid_type "$type" || yeet_die "Unknown commit type: $type"
  printf 'scope [optional]: '
  read -r scope
  printf 'message: '
  read -r message

  if [ -n "$scope" ]; then
    yeet_commit_format "$type" "$scope" "$message"
  else
    yeet_commit_format "$type" "$message"
  fi
  exit 0
}
