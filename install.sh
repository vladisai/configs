#!/usr/bin/env bash
# Bootstrap this dotfiles repo onto a fresh Arch Linux machine.
#
# Usage:
#   ./install.sh            # stow all packages into $HOME
#   ./install.sh --packages # also install pacman + AUR packages first
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(zsh bash nvim tmux i3 i3blocks alacritty rofi gitcfg X scripts)

FAILED_PACKAGES=()

if [[ "${1:-}" == "--packages" ]]; then
  echo "==> Installing pacman packages from packages/pacman.txt"
  # Some packages in a years-old snapshot may no longer exist or may already
  # be provided by something else — install one at a time so one bad name
  # doesn't abort the whole run.
  while read -r pkg; do
    [[ -z "$pkg" ]] && continue
    sudo pacman -S --needed --noconfirm "$pkg" || FAILED_PACKAGES+=("pacman:$pkg")
  done < "$REPO_DIR/packages/pacman.txt"

  if [[ -s "$REPO_DIR/packages/aur.txt" ]]; then
    if ! command -v yay >/dev/null; then
      echo "==> yay not found, installing it first"
      sudo pacman -S --needed --noconfirm git base-devel
      tmpdir=$(mktemp -d)
      git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
      (cd "$tmpdir/yay" && makepkg -si --noconfirm)
    fi
    echo "==> Installing AUR packages from packages/aur.txt"
    while read -r pkg; do
      [[ -z "$pkg" ]] && continue
      yay -S --needed --noconfirm "$pkg" || FAILED_PACKAGES+=("aur:$pkg")
    done < "$REPO_DIR/packages/aur.txt"
  fi
fi

if ! command -v stow >/dev/null; then
  echo "==> Installing GNU Stow"
  sudo pacman -S --needed --noconfirm stow
fi

echo "==> Backing up any pre-existing real files that would conflict with stow"
for pkg in "${PACKAGES[@]}"; do
  [[ -d "$REPO_DIR/$pkg" ]] || continue
  while IFS= read -r -d '' src; do
    rel="${src#"$REPO_DIR"/"$pkg"/}"
    target="$HOME/$rel"
    if [[ -e "$target" && ! -L "$target" ]]; then
      echo "    $target -> $target.pre-configs-backup"
      mv "$target" "$target.pre-configs-backup"
    fi
  done < <(find "$REPO_DIR/$pkg" -type f -print0)
done

echo "==> Stowing dotfiles into $HOME"
stow -d "$REPO_DIR" -t "$HOME" -R "${PACKAGES[@]}"

echo "==> Setting up Vim plugin manager (Vundle)"
if [[ ! -d "$HOME/.vim/bundle/Vundle.vim" ]]; then
  git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
fi
vim +PluginInstall +qall || true

echo "==> Setting up nvim-lspconfig"
LSPCONFIG_DIR="$HOME/.config/nvim/pack/nvim/start/nvim-lspconfig"
if [[ ! -d "$LSPCONFIG_DIR" ]]; then
  git clone https://github.com/neovim/nvim-lspconfig "$LSPCONFIG_DIR"
fi

if [[ ${#FAILED_PACKAGES[@]} -gt 0 ]]; then
  echo
  echo "==> These packages failed to install (renamed/removed upstream, etc) — review by hand:"
  printf '    %s\n' "${FAILED_PACKAGES[@]}"
fi

cat <<'EOF'

==> Done. A few things this script does NOT handle, do them by hand:
  - Copy ~/.ssh keys over securely (never stored in this repo).
  - git config --global user.email / user.name if different on this machine.
  - Any app you log into (Slack, Discord, browsers, etc.) needs its own login.
  - Any *.pre-configs-backup files left behind are pre-existing files that
    would have collided with stow — diff/delete them once you've checked.
EOF
