export ARCH              = arm
export SUBARCH           = armhf
export CROSS_COMPILE     = arm-linux-gnueabihf-
export CONCURRENCY_LEVEL = 10
export PATH             := /opt/arm-linux-gnueabihf/:$(PATH)
export DEB_HOST_ARCH     = $(SUBARCH)

all: linux-sunxi.deb

linux-sunxi/.git:
media_build/.git:
	cd ..; \
	git submodule init; \
	git submodule update

clean:
	rm -f kernel_package/boot
	rm -f kernel_package/lib
	rm -f kernel_package/usr
	rm -f *.deb
	cd linux-sunxi; git reset --hard; git clean -fxd
	cd media_build; git reset --hard; git clean -fxd

menuconfig: linux-sunxi/.config
	cd linux-sunxi; make menuconfig
	cp -a linux-sunxi/.config config

# Config

linux-sunxi/.config: config
	cp -a config linux-sunxi/.config

# uImage

linux-sunxi/arch/arm/boot/uImage: linux-sunxi/.config
	cd linux-sunxi; make -j$(CONCURRENCY_LEVEL) uImage

kernel_package/boot: linux-sunxi/arch/arm/boot/uImage
	mkdir -p kernel_package/boot
	cp -a linux-sunxi/arch/arm/boot/uImage kernel_package/boot/uImage

# Modules

kernel_package/lib: linux-sunxi/.config
	rm -rf kernel_package/lib
	cd linux-sunxi; make -j$(CONCURRENCY_LEVEL) modules	
	cd linux-sunxi; make -j$(CONCURRENCY_LEVEL) INSTALL_MOD_PATH=../kernel_package modules_install
	cd kernel_package/lib/modules/*; unlink source; ln -s build source
	cd kernel_package/lib/modules/*; unlink build; ln -s /usr/src/linux-sunxi-headers build

# Headers

kernel_package/usr/src/linux-sunxi-headers: kernel_package/boot kernel_package/lib
	mkdir -p kernel_package/usr/src/linux-sunxi-headers
	cp -a linux-sunxi/.config kernel_package/usr/src/linux-sunxi-headers/
	cp -a linux-sunxi/Module.symvers kernel_package/usr/src/linux-sunxi-headers/
	cp -a linux-sunxi/Makefile kernel_package/usr/src/linux-sunxi-headers/
	rsync --delete --archive linux-sunxi/include/ kernel_package/usr/src/linux-sunxi-headers/include
	rsync --delete --archive linux-sunxi/scripts/ kernel_package/usr/src/linux-sunxi-headers/scripts

	mkdir -p kernel_package/usr/src/linux-sunxi-headers/arch/arm
	cp -a linux-sunxi/arch/arm/Makefile kernel_package/usr/src/linux-sunxi-headers/arch/arm/
	cp -a -R linux-sunxi/arch/arm/include kernel_package/usr/src/linux-sunxi-headers/arch/arm/
	rsync --delete --archive --include '*/' --include '*.h' --include 'Makefile' --include 'Module.symvers' --exclude '*' linux-sunxi/arch/arm/mach-sun7i/ kernel_package/usr/src/linux-sunxi-headers/arch/arm/mach-sun7i
	rsync --delete --archive --include '*/' --include '*.h' --include 'Makefile' --include 'Module.symvers' --exclude '*' linux-sunxi/arch/arm/plat-sunxi/ kernel_package/usr/src/linux-sunxi-headers/arch/arm/plat-sunxi

	cd linux-sunxi; make CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm HOSTCC=arm-linux-gnueabihf-gcc KBUILD_SCRIPTROOT=../../../../linux-sunxi O=../kernel_package/usr/src/linux-sunxi-headers/ -j1 scripts V=1

# linuxtv modules

media_build/linux/linux-media.tar.bz2:
	cd media_build/linux; make download untar apply_patches KERNELRELEASE=3.4.90

kernel_package/lib/modules/3.4.90+/kernel/drivers/media/em28xx.ko: kernel_package/boot kernel_package/lib kernel_package/usr
	cd media_build/v4l; make allyesconfig VER=3.4.90 KERNELRELEASE=3.4.90 SRCDIR=$(PWD)/linux-sunxi
	cd media_build/v4l; make VER=3.4.90 KERNELRELEASE=3.4.90 SRCDIR=$(PWD)/linux-sunxi -j$(CONCURRENCY_LEVEL)
	cd media_build/v4l; make -C firmware install DESTDIR="../../../kernel_package" VER=3.4.90 KERNELRELEASE=3.4.90 SRCDIR=$(PWD)/linux-sunxi -j$(CONCURRENCY_LEVEL)
	rm -rf kernel_package/lib/modules/3.4.90+/kernel/drivers/media/
	mkdir -p kernel_package/lib/modules/3.4.90+/kernel/drivers/media/
	arm-linux-gnueabihf-strip --strip-debug $(wildcard media_build/v4l/*.ko)
	cp -a media_build/v4l/*.ko kernel_package/lib/modules/3.4.90+/kernel/drivers/media/
	cp -a ./linux-sunxi/drivers/media/video/sunxi/sunxi_cedar_mod.ko kernel_package/lib/modules/3.4.90+/kernel/drivers/media/

# Debian Package

linux-sunxi.deb: kernel_package/usr/src/linux-sunxi-headers kernel_package/lib kernel_package/boot kernel_package/DEBIAN/control kernel_package/lib/modules/3.4.90+/kernel/drivers/media/em28xx.ko
	rm -f linux-sunxi.deb
	/sbin/depmod -b kernel_package/ 3.4.90+
	fakeroot dpkg-deb -b kernel_package linux-sunxi.deb
