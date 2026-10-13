#!/bin/sh
# lf cleaner. Deletes the kitty graphics images that pv.sh drew over the pane.
# Arguments: file width height x y next-file

# a=d,d=A deletes all placements. Inside tmux the sequence has to be wrapped in
# tmux's passthrough DCS, with every escape byte doubled.
if [ -n "$TMUX" ]; then
    printf '\033Ptmux;\033\033_Ga=d,d=A\033\033\\\033\\' > /dev/tty
else
    printf '\033_Ga=d,d=A\033\\' > /dev/tty
fi
