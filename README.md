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
| `iterm`    | iTerm2 profiles/keymap export, for whenever I'm back on a Mac — not stowed into `$HOME`, just kept for reference |

`packages/pacman.txt` and `packages/aur.txt` are `pacman -Qqe` / `pacman -Qqm` snapshots
of explicitly installed packages, for reinstalling the same toolset on a new machine.

## Bootstrap a new machine

If Arch is already installed, this is all you need:

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

If Arch itself isn't installed yet, see the from-scratch install notes below first.

## Updating

Since packages are symlinked, edit files in `$HOME` as usual and the repo stays in
sync — just `cd ~/repos/configs && git add -A && git commit` when you want to snapshot
a change. Re-run `./install.sh` after adding a new package directory.

---

## Installing Arch Linux from scratch

Notes from doing the base OS install itself (before any of the dotfiles above come
into play). Adjust locale/hostname/disk layout/username for the actual machine.

### 1. Create a bootable USB device
Download an ISO from the [Arch downloads page](https://archlinux.org/download/), then:
```dd if=PATH_TO_ISO of=/dev/sdX bs=1M status=progress```
Note: it's `/dev/sdX`, not `/dev/sdX1`.

### 2. Boot the installer
Change boot order in BIOS to load the USB drive. Secure boot may need to be disabled
for the installer to boot.

#### 2.1 Verify boot mode
`ls /sys/firmware/efi/efivars` should produce output.

#### 2.2 Connect to the internet (wifi)
1. Run `iwctl`
2. `device list`, pick the device (e.g. `wlan0`)
3. `station wlan0 scan` then `station wlan0 get-networks`
4. `station wlan0 connect <SSID>`

#### 2.3 Set system clock
```timedatectl set-ntp true```

#### 2.4 Partition the disk
Using `fdisk /dev/sdX`:
1. Create a GPT partition table (`g`) if there isn't one.
2. Create partitions (`n`) — EFI system partition, swap, root. Example layout:
```
Device        Start       End   Sectors   Size Type
/dev/sdb1      2048   1050623   1048576   512M EFI System
/dev/sdb2   1050624  26216447  25165824    12G Linux swap
/dev/sdb3  26216448 250069646 223853199 106.7G Linux filesystem
```
3. Write (`w`), then `mkfs.ext4` the root partition and `mkswap` the swap partition.
4. Mount root to `/mnt`, EFI partition to `/mnt/boot`.

#### 2.5 Pacstrap + fstab
```
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
```
Check `/mnt/etc/fstab` looks right.

### 3. Inside the chroot
`arch-chroot /mnt`, then:

#### 3.1 Time
```
ln -sf /usr/share/zoneinfo/<Region>/<City> /etc/localtime
hwclock --systohc
```

#### 3.2 Locale
Uncomment the needed locales in `/etc/locale.gen`, then:
```
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
```

#### 3.3 Hostname
`echo <hostname> > /etc/hostname`

#### 3.4 Root + user password
```
passwd
useradd -m vlad
passwd vlad
```

#### 3.5 Bootloader (systemd-boot)
```
bootctl install
pacman -S intel-ucode
e2label /dev/sdb2 arch_os
```
Then create `/boot/loader/entries/arch.conf`:
```
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=LABEL=arch_os rw
```

#### 3.6 Install packages
Rather than the old flat `packages` file, use `packages/pacman.txt` /
`packages/aur.txt` from this repo (see "Bootstrap a new machine" above), or:
```
pacman -S --needed - < packages/pacman.txt
```

Reboot into the installed system once done.

### 4. First boot setup

#### 4.1 sudo
```
groupadd sudo
visudo   # uncomment %sudo ALL=(ALL) ALL
usermod -a -G sudo vlad
```

#### 4.2 Networking
```
systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl enable iwd
```
For wifi autoconnect, add to `/etc/iwd/main.conf`:
```
[Settings]
AutoConnect=true
```

#### 4.3 yay (AUR helper)
```
cd /opt
sudo git clone https://aur.archlinux.org/yay.git
sudo chown -R vlad:vlad ./yay
cd yay
makepkg -si
```

#### 4.4 Sound
```
sudo pacman -S pulseaudio pulsemixer
yay -S pulseaudio-ctl
```

#### 4.5 oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
This overwrites `.zshrc` with the stock oh-my-zsh one — at this point just run
`./install.sh` from this repo (see top of README) to symlink the real `.zshrc` and
everything else back into place.
