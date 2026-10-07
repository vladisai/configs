#!/usr/bin/env bash
# Bootstrap this dotfiles repo onto a fresh Arch Linux or macOS machine.
#
# Usage:
#   ./install.sh            # stow this OS's packages into $HOME
#   ./install.sh --packages # Arch only: also install pacman + AUR packages first
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# Stowed on every machine.
COMMON=(zsh nvim tmux alacritty gitcfg ghostty lf ranger zathura)
# Stowed only on that OS. A "-linux" or "-mac" suffix marks the OS-specific
# half of a common package, e.g. zsh-mac/.config/zsh/os.zsh, which .zshrc
# sources.
LINUX=(zsh-linux alacritty-linux bash i3 i3blocks rofi X scripts)
MAC=(zsh-mac alacritty-mac vifm)
# ~/.claude holds Claude Code's state, including credentials. Stowing without
# folding makes sure ~/.claude itself never becomes a symlink into this repo.
NO_FOLDING=(claude)

case "$(uname -s)" in
  Linux) OS=linux; PACKAGES=("${COMMON[@]}" "${LINUX[@]}") ;;
  Darwin) OS=mac; PACKAGES=("${COMMON[@]}" "${MAC[@]}") ;;
  *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

FAILED_PACKAGES=()

if [[ "${1:-}" == "--packages" ]]; then
  if [[ "$OS" != linux ]]; then
    echo "--packages installs from the Arch package lists in packages/, so it only works on Arch." >&2
    exit 1
  fi
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
  case "$OS" in
    linux) sudo pacman -S --needed --noconfirm stow ;;
    mac) brew install stow ;;
  esac
fi

# Moves aside whatever in $HOME would stop stow from linking $1, a path inside
# a package: a real file, or a symlink that points outside this repo. Walks down
# from the top of the path because a parent directory can be the culprit, e.g.
# ~/.config/nvim pointing into another dotfiles checkout. Moving a symlink
# aside never touches what it points to.
clear_the_way() {
  local rel="$1" prefix="" part target
  local IFS=/
  for part in $rel; do
    prefix="${prefix:+$prefix/}$part"
    target="$HOME/$prefix"
    if [[ -L "$target" ]]; then
      case "$(readlink -f -- "$target" 2>/dev/null || true)" in
        "$REPO_DIR"/*) return ;;  # already linked into this repo
      esac
    elif [[ ! -e "$target" ]]; then
      return  # nothing there, stow will create it
    elif [[ -d "$target" && "$prefix" != "$rel" ]]; then
      continue  # a real directory, look further down
    fi
    echo "    $target -> $target.pre-configs-backup"
    mv "$target" "$target.pre-configs-backup"
    return
  done
}

echo "==> Backing up anything in the way of stow"
for pkg in "${PACKAGES[@]}" "${NO_FOLDING[@]}"; do
  while IFS= read -r -d '' src; do
    clear_the_way "${src#"$REPO_DIR"/"$pkg"/}"
  done < <(find "$REPO_DIR/$pkg" \( -type f -o -type l \) -print0)
done

echo "==> Stowing dotfiles into $HOME"
stow -d "$REPO_DIR" -t "$HOME" -R "${PACKAGES[@]}"
stow -d "$REPO_DIR" -t "$HOME" -R --no-folding "${NO_FOLDING[@]}"

echo "==> Installing nvim plugins at the versions in lazy-lock.json"
# lazy.nvim clones itself on the first start, see nvim/.config/nvim/lua/config/lazy.lua.
nvim --headless "+Lazy! restore" +qa

if [[ ${#FAILED_PACKAGES[@]} -gt 0 ]]; then
  echo
  echo "==> These packages failed to install (renamed/removed upstream, etc) — review by hand:"
  printf '    %s\n' "${FAILED_PACKAGES[@]}"
fi

cat <<'EOF2'

==> Done. A few things this script does NOT handle, do them by hand:
  - Copy ~/.ssh keys over securely (never stored in this repo).
  - Put this machine's git user.name / user.email in ~/.gitconfig.local if
    they differ from the ones in gitcfg/.gitconfig.
  - Machine-specific shell setup goes in ~/.zshrc.local.
  - Any app you log into (Slack, Discord, browsers, etc.) needs its own login.
  - Any *.pre-configs-backup files left behind are pre-existing files that
    would have collided with stow — diff/delete them once you've checked.
EOF2
