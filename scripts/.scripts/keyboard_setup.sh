# !/usr/bin/env bash
setxkbmap -model pc104 -layout pl,ru,by -option caps:escape # languages (caps:escape = Caps->Esc via native XKB, so Chromium/Electron apps like Obsidian see it too)

xbindkeys -f /home/vlad/.config/X/.xbindkeysrc # hotkeys 

# modmap
xmodmap /home/vlad/.config/X/.Xmodmap
xset r rate 300 50
