#!/usr/bin/env bash
# Set realistic relative mtimes on demo fixture session files so the
# picker renders 'just now / 15m ago / 3h ago / 2d ago / 8d ago' labels.
#
# Run from the repo root before recording with vhs:
#   bash docs/setup-fixtures.sh
# The demo.tape runs this automatically in its Hide block.
#
# Uses BSD `date -v` (macOS). On Linux, swap to `date -d`.

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/demo-fixtures"

set_mtime() {
  # $1: BSD date -v offset (e.g. -2M, -15M, -3H, -2d, -8d)
  # $2: file (absolute or relative)
  local stamp
  stamp=$(date -v"$1" +%Y%m%d%H%M)
  touch -t "$stamp" "$2"
}

set_mtime -2M  "$DIR/dotfiles/11111111-1111-4111-8111-aaaaaaaaaaaa.jsonl"
set_mtime -15M "$DIR/claude-sessions/22222222-2222-4222-8222-bbbbbbbbbbbb.jsonl"
set_mtime -3H  "$DIR/personal-site/33333333-3333-4333-8333-cccccccccccc.jsonl"
set_mtime -2d  "$DIR/weekend-rust-cli/44444444-4444-4444-8444-dddddddddddd.jsonl"
set_mtime -8d  "$DIR/homelab/55555555-5555-4555-8555-eeeeeeeeeeee.jsonl"
