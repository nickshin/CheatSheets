# SSD tablets &amp; laptops

written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://github.com/nickshin/CheatSheets/>

* * *

## Surface Pro 3 issues

Ubuntu MATE 16.04 - works mostly<br>
Ubuntu Studio 16.04 - will bomb on grub installation

_**NOTE:** just in case grub doesn't stick: follow these wonderful instructions to fix it_
- _<http://superuser.com/questions/376470/how-to-reinstall-grub2-efi>_

* * *
* * *

## prep USB stick

```sh
dd bs=4M if=ubuntu-mate-16.04-desktop-amd64.iso of=/dev/sdX
```

* * *
* * *

## multiboot USB

_i like to test grub configurations first "virtually" on my desktop (much faster) before burning the copies to the USB stick (much slower)..._

### target "device"

##### [ disk image ]

```sh
# 30MB test image - using dummy iso files for testing grub.conf scripts
dd if=/dev/zero of=disk.img bs=1M count=30
DEVICE=disk.img
```

##### [ thumb stick ]

```sh
DEVICE=/dev/sdX    # your USB stick
```

### create partitions

```sh
gdisk $DEVICE
	o
		Y
	n   # BIOS boot - partition #1
		[enter]
		[enter]
		2MiB
		EF02
	n   # EFI System - partition #2
		[enter]
		[enter]
		10MiB   # check with your system: sudo du -cks /boot/efi
		EF00
	n   # your data - partition #3
		[enter]
		[enter]
		[enter]
		[enter]
	r
	h
	1 2 3
	N
	# GPT partition 1
		[enter]
		N
	# GPT partition 2
		[enter]
		N
	# GPT partition 3
		[enter]
		Y
	x
	h
	w
	Y

# or in a single command:
parted --script $DEVICE \
	mklabel gpt \
	mkpart primary fat32 1 128 \
	mkpart primary fat32 1 128 \
	mkpart primary fat32 1 128 \
	set 1 boot on
```

### format partitions

##### [ disk image ]

```sh
sudo apt-get install kpartx    # to create device maps from partition tables
sudo kpartx -l $DEVICE         # list existing partition mapping
sudo kpartx -av $DEVICE        # add partition mapping

sudo mkfs.vfat /dev/mapper/loop0p2
sudo mkfs.ext4 /dev/mapper/loop0p3
mkdir efi mnt
sudo mount /dev/mapper/loop0p2 efi
sudo mount /dev/mapper/loop0p3 mnt
sudo mkdir -p mnt/boot/iso
```

##### [ thumb stick ]

```sh
sudo mkfs.vfat /dev/sdX2
sudo mkfs.ext4 /dev/sdX3
mkdir efi mnt
sudo mount /dev/sdX2 efi
sudo mount /dev/sdX3 mnt
sudo mkdir -p mnt/boot/iso
```

### grub-install

```sh
sudo apt-get install grub-efi-amd64 grub-pc-bin qemu
	# grub-efi-amd64 yields target: x86_64-efi
	# grub-pc-bin qemu yields target: i386-pc
```

the following can be done either/or (UEFI or BIOS boot) -- as well as, in this order (hybrid UEFI GPT + BIOS GPT/MBR boot):
<!--
[//] # ( sudo grub-install --removable --recheck --no-nvram --no-uefi-secure-boot --efi-directory=./mnt --boot-directory=./mnt/boot --target=i386-efi   )
[//] # ( sudo grub-install --removable --recheck --no-nvram --no-uefi-secure-boot --efi-directory=./mnt --boot-directory=./mnt/boot --target=x86_64-efi )
-->

```sh
sudo grub-install --removable --recheck \
				--no-nvram --efi-directory=./efi \
				--boot-directory=./mnt/boot --target=x86_64-efi

sudo grub-install --removable --recheck \
				--no-floppy \
				--boot-directory=./mnt/boot --target=i386-pc \
				/dev/loop0
```

- `mnt/boot/grub` is created
- NOTE: `--{efi,boot}-directory` can be relative to where the command is run

### add grub/iso files

```sh
sudo cp -duvpr grub mnt/boot/.
```

##### [ disk image ]

```sh
# repeat for however many iso files listed in grub.conf
echo dummy | sudo tee mnt/boot/iso/distro_XYZ.iso
```

##### [ thumb stick ]

```sh
sudo cp -duvpr iso mnt/boot/.
```

* * *

### linux ISOs

- goto <http://distrowatch.com> and click on the "Select Distribution" drop down box
	- some interesting ones are:
		- tools
			- [Clonezilla](http://distrowatch.com/table.php?distribution=clonezilla)
			- [GParted](http://distrowatch.com/table.php?distribution=gparted)
			- [SystemRescue](http://distrowatch.com/table.php?distribution=systemrescue)

		- forensics
			- [BackBox](http://distrowatch.com/table.php?distribution=backbox)
			- [Kali](http://distrowatch.com/table.php?distribution=kali)
			- [REMnux](http://distrowatch.com/table.php?distribution=remnux)
			- [Tails](http://distrowatch.com/table.php?distribution=tails)

		- nerds
			- [Alpine](http://distrowatch.com/table.php?distribution=alpine)
			- [Android-x86](http://distrowatch.com/table.php?distribution=androidx86)
			- [CoreOS](http://distrowatch.com/table.php?distribution=coreos)
			- [LFS](http://distrowatch.com/table.php?distribution=lfs)
			- [NixOS](http://distrowatch.com/table.php?distribution=nixos)
			- [Qubes](http://distrowatch.com/table.php?distribution=qubes)
			- [RancherOS](http://distrowatch.com/table.php?distribution=rancheros)

		- utilities
			- [AsteriskNOW](http://distrowatch.com/table.php?distribution=asterisknow)
			- [Elastix](http://distrowatch.com/table.php?distribution=elastix)
			- [Porteus Kiosk](http://distrowatch.com/table.php?distribution=porteuskiosk)
			- [TurnKey](http://distrowatch.com/table.php?distribution=turnkey)

		- multimedia
			- [FreeNAS](http://distrowatch.com/table.php?distribution=freenas)
			- [NAS4Free](http://distrowatch.com/table.php?distribution=nas4free)
			- [OpenMediaVault](http://distrowatch.com/table.php?distribution=openmediavault)
			- [Rockstor](http://distrowatch.com/table.php?distribution=rockstor)

			- [LinHES](http://distrowatch.com/table.php?distribution=linhes)
			- [Mythbuntu](http://distrowatch.com/table.php?distribution=mythbuntu)
			- [OpenELEC](http://distrowatch.com/table.php?distribution=openelec)
			- [OSMC](http://distrowatch.com/table.php?distribution=osmc)

			- [SteamOS](http://distrowatch.com/table.php?distribution=steamos)

		- firewall
			- [ClearOS](http://distrowatch.com/table.php?distribution=clearos)
			- [IPFire](http://distrowatch.com/table.php?distribution=ipfire)
			- [NethServer](http://distrowatch.com/table.php?distribution=nethserver)
			- [pfSense](http://distrowatch.com/table.php?distribution=pfsense)
			- [Untangle](http://distrowatch.com/table.php?distribution=untangle)
			- [OPNsense](http://distrowatch.com/table.php?distribution=opnsense)
<!--
[//] # ( 			- [IPCop](http://distrowatch.com/table.php?distribution=ipcop)           )
[//] # ( 			- [Sophos](http://distrowatch.com/table.php?distribution=sophos)         )
[//] # ( 			- [Smoothwall](http://distrowatch.com/table.php?distribution=smoothwall) )
[//] # ( 			- [Zentyal](http://distrowatch.com/table.php?distribution=zentyal)       )
-->

		- small
			- [Puppy](http://distrowatch.com/table.php?distribution=puppy)
			- [antiX](http://distrowatch.com/table.php?distribution=antix)
			- [Tiny Core](http://distrowatch.com/table.php?distribution=tinycore)
			- [SliTaz](http://distrowatch.com/table.php?distribution=slitaz)

* * *

### clean up

```sh
sudo umount efi
sudo umount mnt
sudo kpartx -d $DEVICE
```

* * *

### rinse and repeat _(disk image centric)_

```sh
sudo kpartx -av disk.img ; sudo mount /dev/mapper/loop0p3 mnt
sudo cp -duvpr grub mnt/boot/.
sudo umount mnt; sudo kpartx -d disk.img
qemu-system-i386 -machine accel=kvm:tcg disk.img -serial stdio
qemu-system-x86_64 -enable-kvm -bios bios.bin disk.img
```

<!--
[//] # ( sudo grub-emu )
-->

- get **bios.bin** from the thread here:
[How to boot EFI kernel using QEMU](http://unix.stackexchange.com/questions/52996/how-to-boot-efi-kernel-using-qemu-kvm)

* * *
* * *

## SSD

### no acccess time

```sh
sudo vi /etc/fstab
```
- NOTE: noatime,nodiratime,discard

```sql
/dev/sdbX / ext4 noatime,nodiratime,discard,errors=remount-ro 0 1
tmpfs /tmp tmpfs defaults 0 0
tmpfs /var/tmp tmpfs defaults 0 0
```

### deadline scheduler

```sh
cat /sys/block/sdX/queue/scheduler
	### ensure [deadline] is used
	### see External Resources links below for details
```

### swappiness

```sh
cat /proc/sys/vm/swappiness
	### make sure it is less than 10
	### 1 is ok, 0 disables swap...

sudo vi /etc/sysctl.conf
	### lower swappieness setting
	### vm.swappiness=1
```

### check health

```sh
sudo smartctl -data -A /dev/sdX
```

- value starts at 100
	- **replace/backup drive at 10 or below**
	- **replace/backup drive at 10 or below**
	- **replace/backup drive at 10 or below**

* * *
* * *

## Screen

### DPI

```sh
sudo vi /etc/X11/xinit/xinitrc
```

- add EOF

```sh
	# ASUS UX305c
	# 1920x1080 13.3"
	xrandr --dpi 166/eDP1
	
	# Microsoft Surface Pro 3
	# 2160×1440 12"
	xrandr --dpi 216/eDP1
```

- find your DPI at <http://dpi.lv/>

### Surface Pro 3

there are 2 ways to control the brightness
- xrandr

```sh
# obtain display
xrandr -q | grep " connected" | awk '{ print $1; }'

# use the display to set the brightness (e.g. eDP1)
xrandr --output eDP1 --brightness 0.5
```

- xbacklight

```sh
sudo apt install backlight
xbacklight -inc 20     # increase backlight by 20%
xbacklight -dec 30     # decrease by 30%
xbacklight -set 80     # set to 80% of max value
xbacklight -get        # get the current level
```

	- bind (inc/dec) commands to keyboard hotkeys

	- and, add the "Brighness Controller" app to the panel

- Note: xrandr will set the overall system brightness.
     xbacklight will be relative to that.

* * *
* * *

## Pointer

### Touchpad
- **System Settings -&gt; Mouse and Touchpad**<br>
	to change several settings including:
	- enabling two finger scrolling
	- also, three and four finger touch gestures works

### Surface Pro 3

```sh
sudo vi /usr/share/X11/xorg.conf.d/10-evdev.conf
```

- add EOF

```sql
Section "InputClass"
	Identifier "Surface Pro 3 cover"
	MatchIsPointer "on"
	MatchDevicePath "/dev/input/event*"
	Driver "evdev"
	Option "vendor" "045e"
	Option "product" "07dc"
	Option "IgnoreAbsoluteAxes" "True"
EndSection
```

- **TODO:** find out how to get (surface pro 3) touchpad option to show up in [ System Settings -&gt; Mouse ]

* * *
* * *

## Power Management

##### TODO: LEFT OFF HERE..
##### TODO: LEFT OFF HERE...
##### TODO: LEFT OFF HERE...
- <https://help.ubuntu.com/community/PowerManagement>
- <https://wiki.ubuntu.com/ReducedPowerUsage>
- <http://www.ubuntugeek.com/how-to-improve-ubuntu-laptop-power-management.html>
- <https://help.ubuntu.com/community/PowerManagement/ReducedPower>
- <https://wiki.archlinux.org/index.php/Power_management>
- <https://wiki.gentoo.org/wiki/Power_management/Guide>

* * *
* * *

## External Resoures

### SSD

- <https://wiki.debian.org/SSDOptimization>
	- everything - including kitchen sink

- <http://www.howtogeek.com/62761/how-to-tweak-your-ssd-in-ubuntu-for-better-performance/>
	- access time
	- trim
	- tmpfs
	- io scheduler

- <http://chriseiffel.com/everything-linux/how-to-set-up-an-ssd-on-linux/>
	- "disk" scheduler
	- "drive" parameters
	- tmp files

- <https://linuxconfig.org/how-to-retrieve-and-change-partitions-universally-unique-identifier-uuid-on-linux>
	- UUID

<!--
[//] # ( - <http://askubuntu.com/a/87122>                       )
[//] # ( 	- ubiquity                                          )
[//] # ( - <https://community.linuxmint.com/tutorial/view/1784> )
[//] # ( 	- rebuilding live installer                         )
-->

### devices

- <https://help.ubuntu.com/community/AsusZenbook>
	- LCD _(DPI)_
	- Touchpad _(multi touch)_

- <https://help.ubuntu.com/community/AsusZenbookPrime#Changing_brightness_workaround_2>
	- Touchpad _(multi touch)_

- <http://askubuntu.com/questions/620726/ubuntu-on-surface-pro-3-or-linux-at-all>
	- surface pro 3 _(touchpad)_


### multiboot USB

- <https://wiki.archlinux.org/index.php/Multiboot_USB_drive>
	- Hybrid UEFI GPT + BIOS GPT/MBR boot
	- a nice list of boot options for a number of distributions
- <https://wiki.archlinux.org/index.php/GUID_Partition_Table>
	- gdisk basic (with hybrid MBR)
<!--
[//] # ( - <https://forums.fogproject.org/topic/7727/building-usb-booting-fos-image/3> )
[//] # ( - <http://wiki.osdev.org/GRUB_2>                                              )
-->

- interesting Grub menu and theme examples
	- <https://github.com/aguslr/multibootusb>
	- <https://github.com/thias/glim>

- [Making a QEMU disk image bootable with GRUB](http://nairobi-embedded.org/making_a_qemu_disk_image_bootable_with_grub.html)
<!--
[//] # ( - [preview your GRUB](http://unix.stackexchange.com/questions/110015/how-can-i-preview-the-grub2-boot-screen) )
-->

* * *

## depricated (surface pro 3) resources

these instructions are no longer needed...<br>
_left here for reference just in case system recovery is needed<br>
(for example) to run firmware updates_

### download a recovery image
- [start from scratch](https://www.microsoft.com/surface/en-us/support/warranty-service-and-recovery/downloadablerecoveryimage)

### have windows partition
do updates and then create a recovery stick
- [still running old win8? upgrade to win10](https://www.microsoft.com/surface/en-us/support/install-update-activate/windows-10-upgrade)
- [do updates](https://www.microsoft.com/surface/en-us/support/performance-and-maintenance/install-software-updates-for-surface)

- [create recovery stick](https://www.microsoft.com/surface/en-us/support/storage-files-and-folders/create-a-recovery-drive)

### boot recovery stick
- (meh...) [if only have win8 recovery stick, but was running win10](https://www.microsoft.com/surface/en-us/support/warranty-service-and-recovery/using-windows-81-bmr-on-windows-10)
- (yes!!!) [full reset](https://www.microsoft.com/surface/en-us/support/warranty-service-and-recovery/restore-or-reset-surface)

### boot linux UEFI stick
- [accessing UEFI](https://www.microsoft.com/surface/en-us/support/warranty-service-and-recovery/how-to-use-the-bios-uefi) (not really needed anymore these days)

* * *

