# configs

My dotfiles, for Arch Linux + i3. Managed with [GNU Stow](https://www.gnu.org/software/stow/):
each top-level directory is a "package" that mirrors the layout of `$HOME`, and
`install.sh` symlinks it all into place.

## Layout

| Package    | What it covers |
|------------|----------------|
| `zsh`      | `.zshrc` (oh-my-zsh, candy theme, `rg`-based `fpath`/`fgrep` helpers) |
| `bash`     | `.bash_profile` / `.bashrc` — `.bash_profile` is what actually starts X (`startx ~/.config/X/.xinitrc`) on tty1 |
| `nvim`     | `.config/nvim` (init.lua, lspconfig+ruff) plus the legacy `.vimrc` / `.vim/colors`, which `cfg.vim` still sources. Plugins are managed by Vundle (declared in `.vimrc`), not vendored in this repo |
| `tmux`     | `.tmux.conf` |
| `i3`       | `.config/i3/config` |
| `i3blocks` | `.config/i3blocks` status bar config |
| `alacritty`| `.config/alacritty/alacritty.yml` |
| `rofi`     | `.config/rofi` |
| `gitcfg`   | `.gitconfig` + `.config/git/ignore` |
| `X`        | `.config/X` (xinitrc, Xresources, Xmodmap, xbindkeysrc) + `.fehbg` |
| `scripts`  | `.scripts/` — i3blocks helpers, pomodoro timer, keyboard setup, etc. |

`packages/pacman.txt` and `packages/aur.txt` are `pacman -Qqe` / `pacman -Qqm` snapshots
of explicitly installed packages, for reinstalling the same toolset on a new machine.

## Bootstrap a new machine

```sh
git clone git@github.com:vladisai/configs.git ~/repos/configs
cd ~/repos/configs
./install.sh --packages   # installs pacman/AUR packages, then stows everything
# or, if you just want the dotfiles symlinked without touching packages:
./install.sh
```

`install.sh` also clones Vundle.vim and runs `:PluginInstall`, and clones
`nvim-lspconfig` into the native nvim package path.

Not handled by the script, on purpose:
- SSH keys (`~/.ssh/*`) — copy those over securely by hand, never commit them.
- Logins for any app (browser, Slack, Discord, etc).
- `git config --global user.email` if it should differ per machine.

## Updating

Since packages are symlinked, edit files in `$HOME` as usual and the repo stays in
sync — just `cd ~/repos/configs && git add -A && git commit` when you want to snapshot
a change. Re-run `./install.sh` after adding a new package directory.
