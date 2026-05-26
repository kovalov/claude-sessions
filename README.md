# claude-sessions

Browse and resume [Claude Code](https://docs.anthropic.com/en/docs/claude-code) sessions from a fuzzy picker. Pick one (or many) sessions, hit Enter, and they open in new tabs / tmux windows / split panes already `cd`'d into the right project and resumed with `claude --resume`.

![demo](docs/demo.gif)

```
claude › ▎
  2m ago   dotfiles                  fix the tmux prefix on linux
  17m ago  claude-sessions           add --json output flag to the picker
  3h ago   personal-site             rewrite the about page in mdx
  2d ago   weekend-rust-cli          port the json parser to nom
```

The picker shows recency, project name, and the first real user prompt — so you can find the conversation you actually want, not just a session ID.

## Requirements

- Python 3.9+
- [`fzf`](https://github.com/junegunn/fzf) on `PATH` — `brew install fzf` / `apt install fzf`
- Claude Code; reads its session logs from `~/.claude/projects/`
- A supported terminal backend (either is fine):
  - **tmux** — works on macOS and Linux. Run claude-sessions from inside a tmux session.
  - **iTerm2** — macOS only. Used automatically when `$TMUX` is not set.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/kovalov/claude-sessions/main/install.sh | bash
```

Installs to `~/.local/bin/claude-sessions`. The installer warns if `fzf` or a supported terminal isn't available.

Or grab the script directly:

```sh
curl -fsSL https://raw.githubusercontent.com/kovalov/claude-sessions/main/bin/claude-sessions \
  -o ~/.local/bin/claude-sessions && chmod +x ~/.local/bin/claude-sessions
```

## Usage

```sh
claude-sessions [--projects-dir <path>] [--terminal {auto,iterm,tmux}]
```

| Key | iTerm | tmux |
| --- | --- | --- |
| `Enter` | New tabs in current window | New tmux windows |
| `Ctrl-O` | New iTerm window | Same as Enter (tmux has no separate window concept) |
| `Ctrl-V` | Split panes in current tab | `tmux split-window` (alternating v/h) |
| `Tab` | Toggle multi-select | Toggle multi-select |
| `Esc` | Close picker | Close picker |

Each opened tab / window / pane runs `cd <project-cwd> && claude --resume <session-id>`.

### Flags

- `--projects-dir <path>` — scan a different directory instead of `~/.claude/projects/`. Useful for backup directories.
- `--terminal {auto,iterm,tmux}` — force a backend. `auto` (default) picks tmux if `$TMUX` is set, otherwise iTerm2 if available.

## How it works

1. Scans `<projects-dir>/*/*.jsonl` (Claude Code's per-session transcripts).
2. Extracts the project working directory and the first non-system user prompt from each session. Metadata is cached at `~/.cache/claude-sessions.json` keyed by file mtime, so repeated runs are instant. Deleted sessions are pruned from the cache on the next run.
3. Pipes a colorized list into `fzf` with a live preview of recent turns.
4. On a keybind, dispatches to the active backend (iTerm via AppleScript or `tmux` CLI) to open windows / panes.

## Demo recording

`docs/demo.tape` is a [vhs](https://github.com/charmbracelet/vhs) script. To regenerate `docs/demo.gif`:

```sh
brew install vhs
vhs docs/demo.tape
```

The recording reads from `docs/demo-fixtures/` (synthetic session data committed to the repo), not your real `~/.claude/projects/`. `docs/setup-fixtures.sh` resets the fixture mtimes so the relative timestamps look natural; the tape runs it automatically.

## Limitations

- Sessions without a recorded `cwd` are hidden (rare, happens with very short sessions).
- In tmux, `Ctrl-O` is identical to `Enter` — tmux doesn't have a separate window-vs-tab concept to map onto.

## License

MIT — see [LICENSE](LICENSE).
