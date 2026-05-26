#!/usr/bin/env bash
# claude-sessions installer
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/kovalov/claude-sessions/main/install.sh | bash
#
# What it does:
#   - Verifies Python 3 is available
#   - Warns if fzf is missing, or if neither tmux nor iTerm2 is present
#   - Downloads bin/claude-sessions to ~/.local/bin and makes it executable
#   - Reminds you to add ~/.local/bin to PATH if it isn't already

set -euo pipefail

REPO_USER="${CLAUDE_SESSIONS_REPO_USER:-kovalov}"
REPO_NAME="${CLAUDE_SESSIONS_REPO_NAME:-claude-sessions}"
REPO_BRANCH="${CLAUDE_SESSIONS_REPO_BRANCH:-main}"
RAW_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${REPO_BRANCH}/bin/claude-sessions"

INSTALL_DIR="${CLAUDE_SESSIONS_INSTALL_DIR:-$HOME/.local/bin}"
INSTALL_PATH="$INSTALL_DIR/claude-sessions"

red()    { printf '\033[31m%s\033[0m\n' "$*"; }
yellow() { printf '\033[33m%s\033[0m\n' "$*"; }
green()  { printf '\033[32m%s\033[0m\n' "$*"; }
dim()    { printf '\033[2m%s\033[0m\n' "$*"; }

if ! command -v python3 >/dev/null 2>&1; then
  red "python3 not found. Install Python 3 (e.g. brew install python / apt install python3) and re-run."
  exit 1
fi

missing_runtime=0
if ! command -v fzf >/dev/null 2>&1; then
  yellow "fzf not found. Install with: brew install fzf  (or: apt install fzf)"
  missing_runtime=1
fi

backend_available=0
if command -v tmux >/dev/null 2>&1; then
  backend_available=1
fi
if [[ "$(uname -s)" == "Darwin" ]] && \
   [[ -d "/Applications/iTerm.app" || -d "$HOME/Applications/iTerm.app" ]]; then
  backend_available=1
fi
if [[ $backend_available -eq 0 ]]; then
  yellow "No terminal backend detected. Install one of:"
  yellow "  - tmux    (brew install tmux  /  apt install tmux)"
  yellow "  - iTerm2  (macOS only, https://iterm2.com)"
  missing_runtime=1
fi

mkdir -p "$INSTALL_DIR"

dim "Downloading $RAW_URL"
if ! curl -fsSL "$RAW_URL" -o "$INSTALL_PATH"; then
  red "Download failed. Check that REPO_USER is set correctly (currently: $REPO_USER)."
  exit 1
fi
chmod +x "$INSTALL_PATH"

green "Installed: $INSTALL_PATH"

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    yellow "$INSTALL_DIR is not on your PATH."
    echo "  Add this to your shell config (~/.zshrc or ~/.bashrc):"
    echo "    export PATH=\"$INSTALL_DIR:\$PATH\""
    ;;
esac

if [[ $missing_runtime -eq 0 ]]; then
  green "Ready. Run: claude-sessions"
else
  yellow "Install the missing dependencies above, then run: claude-sessions"
fi
