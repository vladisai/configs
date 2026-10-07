# Linux part of ~/.zshrc, sourced from there.

# Start X when logging in on tty1, same as bash/.bash_profile does for bash.
if [[ -z ${DISPLAY} ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx ~/.config/X/.xinitrc > ~/last_log
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/vlad/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/vlad/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/vlad/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/vlad/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="$HOME/apps/unison/bin:$PATH"
