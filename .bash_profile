#
# ~/.bash_profile
#

alias rm="echo rm is disabled. Use del to move to trash, or use /bin/rm."
alias del="mv -t .trash"

[[-f ~/.bashrc ]] && . ~/.bashrc

if [[ ! ${DISPLAY} && ${XDG_VTNR} == 2 ]]; then
	exec startx ~/.xinitrc xfce 
else
	exec startx ~/.xinitrc i3
fi
