# My guide to installing arch linux on my machine. 

## 1. Create a bootable usb device. 
This is easily done using dd. Just go to downloads page [here](https://archlinux.org/download/). Then, once downloaded, run:
```dd if=PATH_TO_ISO of=/dev/sdX bs=1M status=progress```
Note, it's `/dev/sdX`, not `/dev/sdX1`.

## 2. Setup using the bootable drive.
Change the needed in bios to load into the usb drive. You may need to disable secure boot because the installation usb 
doesn't work with that. 

Once loaded into the usb, follow the first few steps in the installation guide. 

### 2.1 Verify boot mode
Just run the command below and make sure it produces some output:
`ls /sys/firmware/efi/efivars`

### 2.2 Connect to the internet

#### Wifi
I used iwctl on the laptop. When connecting, simpy:
1. Run `iwctl`
2. Inside that `device list`. Pick your needed device. I'll use `wlan0` as example for now.
3. Then run `station wlan0 scan` and `station wlan0 get-networks`. Pick the network. I'll use `D25`.
4. Then run `station wlan0 scan` and `station wlan0 connect D25`.
5. You should be good.

### 2.3 Set system clock
```timedatectl set-ntp true```

### 2.4 Prepare the disk
I used `fdisk`. The steps:
1. `fdisk` to open the interface.
2. Create GPT partition table with `g` command if there's no table yet.
3. Create partitions using `n` commands. (1 swap, 1 boot). My current table is here: 
```
Device        Start       End   Sectors   Size Type
/dev/sdb1      2048   1050623   1048576   512M EFI System
/dev/sdb2   1050624  26216447  25165824    12G Linux swap
/dev/sdb3  26216448 250069646 223853199 106.7G Linux filesystem
```
4. Write using `w`.
5. Once done, format partitions using `mkfs.ext4` and `mkswap`
6. Mount the root partition to `/mnt` and the EFI partition to `/mnt/boot`.

### 2.5 Run pacstrap
```pacstrap /mnt base linux linux-firmware```
Then generate fstab:
```genfstab -U /mnt >> /mnt/etc/fstab```
Make sure it's correct.

## 3 Steps in chroot
This section is what we do in chroot. So, first we do `arch-chroot /mnt`.

### 3.1 Set time
```
ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime
hwclock --systohc
```

### 3.2 Locale
Edit /etc/locale.gen and uncomment en_US, pl_PL, and ru_RU. Generate the locales by running:
```
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
```

### 3.3 Hostname
```
export yooo > /etc/hostname
```

### 3.4 Set password for root and my user
```
passwd
useradd -m vlad
passwd vlad
```

### 3.5 Install bootloader
I use systemd. For that, if '/boot' is mounted, we just run `bootctl install`. In order to add intel-ucode. I also did
`pacman -S intel-ucode`.
Then, I added the label to the partition containing arch linux:
```e2label /dev/sdb2 arch_os```. 
Now we're ready to create config for systemd:
``` 
# put this into /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=LABEL=arch_os rw
```
This will find the disk by its label and load the os from it. 

### 3.6 Install needed packages
The list is provided in the file named `packages`.
To install from it, we can use:
```
pacman -S $(cat yourfilename | cut -d' ' -f1)
```

Now we're ready to reboot into actual arch.

## 4. Setup after booting
### 4.1 Setting up sudo
1. `groupadd sudo`
2. Run `visudo`. Uncomment `%sudo   ALL=(ALL) ALL`.
3. `usermod -a -G sudo vlad`

### 4.2 Setting up

To make internet work systemd-networkd, systemd-resolved, systemd-
