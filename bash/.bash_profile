#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ -z ${DISPLAY} ]] && [[ $(tty) = /dev/tty1 ]]; then
   	exec startx ~/.config/X/.xinitrc > ~/last_log
    . ~/.scripts/keyboard_setup.sh
fi
