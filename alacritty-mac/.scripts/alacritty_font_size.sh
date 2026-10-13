#!/bin/bash
# Toggles alacritty's font size between two values. Bound to Cmd+; in
# ~/.config/alacritty/os.toml.

# os.toml is a symlink into the configs repo. sed -i would replace the symlink
# with a plain file, so edit the file it points to.
CONFIG="$(readlink -f "$HOME/.config/alacritty/os.toml")"
SMALL_SIZE="16.0"
LARGE_SIZE="18.0"  # or whatever size you want

current=$(grep "^size = " "$CONFIG" | grep -o "[0-9.]*")

if [ "$current" = "$SMALL_SIZE" ]; then
    sed -i '' "s/^size = .*/size = $LARGE_SIZE/" "$CONFIG"
else
    sed -i '' "s/^size = .*/size = $SMALL_SIZE/" "$CONFIG"
fi
