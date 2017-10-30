#
# ~/.bash_profile
#
[[ -f ~/.config/.bashrc ]] && . ~/.config/.bashrc

if [[ ! ${DISPLAY} && ${XDG_VTNR} == 2 ]]; then
	exec startx ~/.config/X/.xinitrc xfce 
else
	exec startx ~/.config/X/.xinitrc i3
fi

# OPAM configuration
. /home/vlad/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
