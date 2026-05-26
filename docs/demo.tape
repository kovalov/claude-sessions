# vhs script that records docs/demo.gif for the README.
# Install vhs: brew install vhs
# Then run:    vhs docs/demo.tape

Output docs/demo.gif

Set Shell "zsh"
Set FontSize 14
Set Width 1100
Set Height 650
Set Theme "Dracula"
Set Padding 20
Set TypingSpeed 60ms

# Launch the picker.
Type "claude-sessions"
Sleep 300ms
Enter
Sleep 1500ms

# Narrow the list by typing into fzf.
Type "claude"
Sleep 1s

# Move down a few rows.
Down
Sleep 300ms
Down
Sleep 300ms
Down
Sleep 300ms

# Multi-select two sessions.
Tab
Sleep 300ms
Up
Sleep 300ms
Tab
Sleep 600ms

# Open them in new tabs / tmux windows.
Enter
Sleep 3s
