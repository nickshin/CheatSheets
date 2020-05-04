## External Links: Linux

written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://github.com/nickshin/CheatSheets/>

* * *

The external links list was getting so large, I placed them here.

* * *

## Linux

#### Containers
- [Awesome Microservices](https://github.com/mfornos/awesome-microservices) (A curated list of Microservice Architecture related principles and technologies.)
- [New Stack Ebook Series](https://thenewstack.io/ebookseries)
	- The Docker &amp; Container Ecosystem
	- Applications &amp; Microservices with Docker &amp; Container
	- Automation &amp; Orchestration with Docker &amp; Containers
	- Networking, Security &amp; Storage with Docker &amp; Containers
	- Monitoring &amp; Management with Docker &amp; Containers

#### Unikernel
- [Unikernel and Immutable Infrastructures](https://github.com/cetic/unikernels)
	- excellent list and summary of a lot things in the unikernel universe
- [awesome-unikernels](https://github.com/infoslack/awesome-unikernels)
	- a pile of links to jump start from

noteables:
- [UniK](https://github.com/emc-advanced-dev/unik) (The Unikernel Compilation and Deployment Platform)
	- Go
	- Node.js
	- Python3
	- Java
	- C/C++
- [NanoVMs](https://www.nanovms.com/)  (can run any valid ELF binary)

#### kernel development
- [Interactive map of Linux kernel](http://www.makelinux.net/kernel_map/)
- [Kbuild: the Linux Kernel Build System](http://www.linuxjournal.com/content/kbuild-linux-kernel-build-system) (linuxjournal)
- [Write your first Linux Kernel module](http://www.linuxvoice.com/be-a-kernel-hacker/) (linuxvoice)
- [Linux Kernel Module Programming](http://www.youtube.com/playlist?list=PL16941B715F5507C5) (youtube)

* * *

## Packages

#### MUST HAVES:

- [Homebrew](https://brew.sh/) (OSX)

<!--
- [SuperDuper!](https://www.shirt-pocket.com/SuperDuper/SuperDuperDescription.html) (hackintoshing)
- [Linuxbrew](http://linuxbrew.sh/) (Linux)
- [Scoop](http://scoop.sh/) (Windows) and
-->

- [Git for Windows](https://git-scm.com/download/win) (Git-Bash)
	- [msys2 pacman docs](https://www.msys2.org/wiki/Using-packages/)
		- [msys2 repo](http://repo.msys2.org/msys/x86_64/)
		- [msys2 packages](https://packages.msys2.org/updates)
	- [How are msys, msys2, and msysgit related to each other?](http://stackoverflow.com/a/35099458)

- [Synergy](https://github.com/symless/synergy-core)

- [Asuswrt-Merlin](https://github.com/RMerl/asuswrt-merlin.ng)
	- see wiki for great details!
	- [the Asuswrt-Merlin Terminal Menu](https://diversion.ch/amtm.html)
		- note: Starting with Asuswrt-Merlin 384.15, amtm is included in the firmware!
	- "stateful" settings (easier reorder/sort via CLI vs web GUI):

```sh
# EVERYTHING
nvram show

# local machines: - get current details
nvram get custom_clientlist        # Network Map - Clients: View List
nvram get dhcp_staticlist          # LAN - DHCP Server - Manually Assigned IP: IP Address
nvram get dhcp_hostnames           # LAN - DHCP Server - Manually Assigned IP: Hostname
nvram get vts_rulelist             # WAN - Port Forwarding - List


# edit values
nvram set custom_clientlist="<ClientName>ClientMACAddress>0>0>>..."		# note: last number may not be 0
nvram set dhcp_staticlist="<MACaddress>IPAddress..."
nvram set dhcp_hostnames="<MACaddress>Hostname..."
nvram set vts_rulelist="<ServiceName>ExternalPort>InternalIPAddress>InternalPort>Protocol>..."


# done
nvram commit
reboot

```

#### Nice to Have:
- [Apache Guacamole](http://guacamole.incubator.apache.org/)

<!--
[//] # ( https://github.com/glyptodon/guacamole-server )
[//] # ( https://github.com/glyptodon/guacamole-client )
-->

- [TigerVNC](http://tigervnc.org/)

* * *

## Distros

#### upgrade | new install
- [apt-get upgrade and clean up script](http://ubuntuforums.org/showthread.php?t=1113808)
- [Linux: Get List of Installed Software for Reinstallation / Restore All the Software Programs](http://www.cyberciti.biz/tips/linux-get-list-installed-software-reinstallation-restore.html)
- [backup and restore installed packages](http://askubuntu.com/a/99151)
- [enable / disable services](http://askubuntu.com/questions/19320/how-to-enable-or-disable-services)

#### optimizations
- [Make Linux faster, lighter and more powerful](https://www.techradar.com/news/computing/pc/make-linux-faster-lighter-and-more-powerful-641317)
- [Fedora 17 Boot Optimization (from 15 to 2.5 seconds)](https://harald.hoyer.xyz/2013/11/13/fedora-boot-optimization/)

#### hackintosh
my notes:
- [Success Stories: 2990wx - 10.15.4](https://forum.amd-osx.com/viewtopic.php?f=35&t=10515) _(latest)_
- [Success Stories: 2990wx - 10.13.6](https://forum.amd-osx.com/viewtopic.php?f=35&t=6583) _(old)_

must reads:
- [AMD OS X Vanilla Guide](https://vanilla.amd-osx.com/)
- [OpenCore Desktop Guide](https://desktop.dortania.ml/)

also, a !!! **FANTASTIC** !!! project to resurrect and install **latest macOS** on **old** (i.e. unsupported) mac machines:
- [DosDude1's macOS Patcher](http://dosdude1.com/software.html)

#### fixes
- [Swap CTRL &amp; CapsLock (everywhere)](http://askubuntu.com/questions/149971/how-do-you-remap-a-key-to-the-caps-lock-key-in-xubuntu#223674)
- [Customize the Xfce menu](https://wiki.xfce.org/howto/customize-menu)
- [How To Make the Mac OS X Finder Suck Less](http://www.howtogeek.com/howto/33414/how-to-make-the-mac-os-x-finder-suck-less/)
- [Mathias Bynens: dotfiles: macos](https://github.com/mathiasbynens/dotfiles/blob/master/.macos) - SUPER !!!
- [Create symlink with Msys2](http://superuser.com/a/1044337)

#### firewall distros
- [untangle](https://github.com/untangle/ngfw_src)
- [pfsense](https://github.com/pfsense)
- [asuswrt-merlin](https://github.com/RMerl/asuswrt-merlin.ng)

- handy summary of open source firewall distros:
	- [David Pavina: Mondaiji](https://www.mondaiji.com/blog/other/it/10175-the-hunt-for-the-ultimate-free-open-source-firewall-distro)

* * *

