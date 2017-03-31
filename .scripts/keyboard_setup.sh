# !/usr/bin/env bash
xrdb -merge ~/.config/X/.Xresources # theme

xbindkeys -f ~/.config/X/.xbindkeysrc # hotkeys

setxkbmap -model pc104 -layout pl,ru -option grp:alt_shift_toggle # languages

# modmap
xmodmap ~/.config/X/.Xmodmap

xset r rate 300 50
