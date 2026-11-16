# macOS part of ~/.zshrc, sourced from there.

eval "$(/opt/homebrew/bin/brew shellenv)"

# mise is installed through Homebrew, so it has to come after brew shellenv.
eval "$(mise activate zsh)"

# Loading conda in every new shell is slow, so run conda_zsh when you need it.
# It puts conda's python first on PATH, ahead of mise's. Don't run
# `conda init zsh`, which would add the slow block back to ~/.zshrc.
conda_zsh() {
    eval "$(/opt/homebrew/Caskroom/miniconda/base/bin/conda shell.zsh hook)"
}
