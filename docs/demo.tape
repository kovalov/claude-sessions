# vhs script that records docs/demo.gif for the README.
# Run from the repo root:  vhs docs/demo.tape
# Requires: vhs (brew install vhs)
#
# Uses docs/demo-fixtures/ (committed, sanitized session data) so the
# recording never touches the real ~/.claude/projects/.

Output docs/demo.gif

Set Shell "zsh"
Set FontSize 14
Set Width 1100
Set Height 650
Set Theme "Dracula"
Set Padding 20
Set TypingSpeed 60ms

# Setup (hidden):
#   - reset fixture mtimes so timestamps render as "2m ago / 15m ago / ..."
#   - prepend the repo's bin/ so we run the in-tree script, not ~/.local/bin
#   - clear screen
Hide
Type "bash docs/setup-fixtures.sh && export PATH=$PWD/bin:$PATH && clear"
Enter
Sleep 600ms
Show

Type "claude-sessions --projects-dir docs/demo-fixtures"
Sleep 300ms
Enter
Sleep 1800ms

# Browse
Down
Sleep 500ms
Down
Sleep 500ms

# Multi-select two sessions
Tab
Sleep 500ms
Up
Sleep 500ms
Tab
Sleep 1s

# Close picker without dispatching (no real terminals spawn during render)
Escape
Sleep 600ms
