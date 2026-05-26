# claude-sessions

Browse and resume [Claude Code](https://docs.anthropic.com/en/docs/claude-code) sessions from a fuzzy picker. Pick one (or many) sessions, hit Enter, and they open as iTerm2 tabs already `cd`'d into the right project and resumed with `claude --resume`.

```
claude › ▎
  2m ago   dotfiles                  fix the tmux prefix on linux
  17m ago  claude-sessions           add --json output flag to the picker
  3h ago   personal-site             rewrite the about page in mdx
  2d ago   weekend-rust-cli          port the json parser to nom
```

The picker shows recency, project name, and the first real user prompt — so you can find the conversation you actually want, not just a session ID.

## Requirements

- macOS (uses `osascript` to drive iTerm)
- [iTerm2](https://iterm2.com) — Terminal.app is not supported
- Python 3.9+
- [`fzf`](https://github.com/junegunn/fzf) on `PATH` — `brew install fzf`
- Claude Code (obviously); reads its session logs from `~/.claude/projects/`

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/kovalov/claude-sessions/main/install.sh | bash
```

Installs to `~/.local/bin/claude-sessions`. If that directory isn't on your PATH, the installer will tell you.

Or grab the script directly:

```sh
curl -fsSL https://raw.githubusercontent.com/kovalov/claude-sessions/main/bin/claude-sessions \
  -o ~/.local/bin/claude-sessions && chmod +x ~/.local/bin/claude-sessions
```

## Usage

```sh
claude-sessions
```

| Key | Action |
| --- | --- |
| `Enter` | Open selection(s) as tabs in the current iTerm window |
| `Ctrl-O` | Open as a new iTerm window with selection(s) as tabs |
| `Ctrl-V` | Open as split panes inside the current iTerm tab |
| `Tab` | Toggle multi-select |
| `Esc` | Close picker |

Each opened tab runs `cd <project-cwd> && claude --resume <session-id>`.

## How it works

1. Scans `~/.claude/projects/*/*.jsonl` (Claude Code's per-session transcripts).
2. Extracts the project working directory and the first non-system user prompt from each session. Metadata is cached at `~/.cache/claude-sessions.json` keyed by file mtime, so repeated runs are instant.
3. Pipes a colorized list into `fzf` with a live preview of recent turns.
4. On a keybind, dispatches an AppleScript to iTerm to open new tabs / window / panes.

## Limitations

- macOS + iTerm2 only. PRs welcome for tmux / Linux terminals.
- Sessions without a recorded `cwd` are hidden (rare, but happens with very short sessions).
- The cache currently doesn't evict deleted sessions (it grows slowly; safe to `rm ~/.cache/claude-sessions.json` anytime).

## License

MIT — see [LICENSE](LICENSE).
