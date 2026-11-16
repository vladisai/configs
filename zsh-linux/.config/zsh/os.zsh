# Linux part of ~/.zshrc, sourced from there.

# Start X when logging in on tty1, same as bash/.bash_profile does for bash.
if [[ -z ${DISPLAY} ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx ~/.config/X/.xinitrc > ~/last_log
fi

# Loading conda in every new shell is slow, so run conda_zsh when you need it.
# Don't run `conda init zsh`, which would add the slow block back to ~/.zshrc.
conda_zsh() {
    eval "$(/home/vlad/miniforge3/bin/conda shell.zsh hook)"
}

export PATH="$HOME/apps/unison/bin:$PATH"

# uv
export PATH="$HOME/.local/bin:$PATH"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
