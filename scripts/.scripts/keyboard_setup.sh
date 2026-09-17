# !/usr/bin/env bash
setxkbmap -model pc104 -layout pl,ru,by # languages

xbindkeys -f /home/vlad/.config/X/.xbindkeysrc # hotkeys 

# modmap
xmodmap /home/vlad/.config/X/.Xmodmap
xset r rate 300 50
