# written by Nick Shin - nick.shin@gmail.com
# the code found in this file is licensed under:
# - Unlicense - http://unlicense.org/
#
# this file is from https://www.nickshin.com/CheatSheets/


# LLVMLinux with LLVM, Clang and LLDB


BUILDHOME=$PWD


# ============================================================
# building just the kernel with an existing clang toolchain
# http://llvm.linuxfoundation.org/index.php/Main_Page

sudo apt-get clang # or build from source

cd "$BUILDHOME"
git clone http://git.linuxfoundation.org/llvmlinux/kernel.git
# note: branches are dated and master is rebased regularly
# e.g. remotes/orgin/llvmlinux-2014.09.16


cd kernel
# build kernel, making sure to set HOSTCC/CC and optionally ARCH/CROSS_COMPILE
#
# For native compiling (like for x86_64):
make HOSTCC=clang CC=clang

# For cross:
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- HOSTCC=clang CC=clang

# For cross:
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=clang CC=clang

# You may find you need to set GCC_TOOLCHAIN=<path-to-your-gcc-cross-toolchain> if the above doesn't work.


# ============================================================
# Automated Build Framework - builds Clang/LLVM, Linux kernel and testing framework
# http://llvm.linuxfoundation.org/index.php/Quick_Start_Guide
# http://llvm.linuxfoundation.org/index.php/Automated_Build_Framework
 
# LLVMLinux code
cd "$BUILDHOME"
git clone http://git.linuxfoundation.org/llvmlinux.git

# build dependancies
sudo apt-get install build-essential cmake git git-svn kpartx libglib2.0-dev patch quilt \
                     rsync subversion zlib1g-dev flex libfdt1 libfdt-dev \
                     libpixman-1-0 libpixman-1-dev

# If you are building this on a x86_64 machine, you may have to install the i386 libraries for the cross compiler:
sudo apt-get install libc6:i386 libncurses5:i386

# If you want to build the (ARM) LTP image from scratch on a Debian/Ubuntu system:
sudo apt-get install linaro-image-tools

 
# some extra helpfull sources to read through to help figure out how to build LLVMLinux
#
# building kernel with native (package repository) LLVM and clang:
# https://aur.archlinux.org/packages/llvmlinux-git/
#
# checking out and building both kernel and toolchain:
# https://aur.archlinux.org/packages/llvmlinux-git-git/


# ------------------------------------------------------------
# building the code:

cd "$BUILDHOME/llvmlinux"
# ls targets
# beaglebone galaxys3 i586 malta msm nexus7 rpi vexpress x86_64

# or
make list-targets


# for example:
	cd "$BUILDHOME/llvmlinux/targets/vexpress"
	# Next build llvm, clang, the linux (patched linux kernel) and qemu.
	make

	# ........................................
	# http://llvm.linuxfoundation.org/index.php/I586
	cd "$BUILDHOME/llvmlinux/targets/i586"
	make

	# ........................................
	# http://llvm.linuxfoundation.org/index.php/X86_64
	# note: need native GCC compiler
	# build tiny first
	cd "$BUILDHOME/llvmlinux/targets/x86_64_tiny"
	make kernel-build test

	# now, the bigger target
	cd "$BUILDHOME/llvmlinux/targets/x86_64"
	make kernel-build

	# if using prebuilt clang: modify llvmlinux/config/make-kernel.sh

	# note: config file for x86_64 is in llvmlinux/targets/x86_64/config_x86_64

	# testing the kernel
	cd "$BUILDHOME/llvmlinux/target/x86_64/src/linux"
	sudo make module_install
	sudo make install

make test

# ------------------------------------------------------------
# updating the sources
make sync-all
make


# ============================================================
# Manual Build Instructions
# http://llvm.linuxfoundation.org/index.php/Manual_Build_Instructions

# ........................................
# LLVM and CLANG
mkdir "$BUILDHOME/llvm4linux"

cd "$BUILDHOME/llvm4linux"
git clone http://llvm.org/git/llvm.git

cd "$BUILDHOME/llvm4linux/llvm/tools"
git clone http://llvm.org/git/clang.git

cd "$BUILDHOME/llvm4linux/llvm"
./configure --prefix=$(echo "$BUILDHOME/llvm4linux")/out/llvm --enable-optimized --disable-assertions --targets=x86,x86_64,arm
make
make install


# ........................................
# qemu

cd "$BUILDHOME/llvm4linux"
wget -nd "http://releases.linaro.org/latest/components/toolchain/qemu-linaro/qemu-linaro-1.0-2011.12.tar.gz"
tar -xzvf qemu-linaro-*.tar.gz
cd qemu-linaro-*
./configure --prefix=$(echo "$BUILDHOME/llvm4linux")/out/qemu-linaro
make
make install


# ........................................
# linux kernel

cd "$BUILDHOME/llvm4linux"
git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

# building ARM kernel
cd "$BUILDHOME/llvm4linux"
wget -nd "https://sourcery.mentor.com/sgpp/lite/arm/portal/package9728/public/arm-none-linux-gnueabi/arm-2011.09-70-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2"
tar -xjvf arm-2011.09-70-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2


# ============================================================
# Debugging Kernel

# http://www.linux-magazine.com/Online/Features/Qemu-and-the-Kernel

