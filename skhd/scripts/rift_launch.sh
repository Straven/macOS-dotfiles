#!/bin/bash

set -euo pipefail

app_name="${1:-}"
workspace_id="${2:-}"
bundle_id="${3:-}"

if [[ -z "$app_name" ]]; then
  echo "usage: rift_launch.sh <app_name> [workspace_id] [bundle_id]" >&2
  exit 1
fi

open_app() {
  local open_args=(-g)

  if [[ -n "$bundle_id" ]]; then
    open "${open_args[@]}" -b "$bundle_id"
  else
    open "${open_args[@]}" -a "$app_name"
  fi
}

if [[ -n "$workspace_id" ]] && command -v rift-cli >/dev/null 2>&1; then
  open_app
  rift-cli execute workspace switch "$workspace_id"
else
  if [[ -n "$bundle_id" ]]; then
    open -b "$bundle_id"
  else
    open -a "$app_name"
  fi
fi
