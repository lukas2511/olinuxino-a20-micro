export ARCH              = arm
export SUBARCH           = armhf
export CROSS_COMPILE     = arm-linux-gnueabihf-
export CONCURRENCY_LEVEL = 10
export DEB_HOST_ARCH     = $(SUBARCH)
export VERSION           = sunxi-next
export FULLVERSION       = 3.15.0-rc6-130763-g119918d

all: linux-$(VERSION).deb

linux-$(VERSION):
	wget -c https://www.kernel.org/pub/linux/kernel/v3.x/testing/linux-$(VERSION).tar.xz
	tar xf linux-$(VERSION).tar.xz

clean:
	rm -rf kernel_package/boot
	rm -rf kernel_package/lib
	rm -rf kernel_package/usr
	rm -f *.deb
	cd linux-$(VERSION); git reset --hard; git clean -fxd

menuconfig: linux-$(VERSION)/.config
	cd linux-$(VERSION); make menuconfig
	cp -a linux-$(VERSION)/.config config

# Config

linux-$(VERSION)/.config: config
	cp -a config linux-$(VERSION)/.config

# uImage

linux-$(VERSION)/arch/arm/boot/uImage: linux-$(VERSION)/.config
	cd linux-$(VERSION); make -j$(CONCURRENCY_LEVEL) LOADADDR=0x40008000 uImage dtbs

kernel_package/boot: linux-$(VERSION)/arch/arm/boot/uImage
	mkdir -p kernel_package/boot
	cp -a linux-$(VERSION)/arch/arm/boot/uImage kernel_package/boot/uImage

# Modules

kernel_package/lib: linux-$(VERSION)/.config
	rm -rf kernel_package/lib
	cd linux-$(VERSION); make -j$(CONCURRENCY_LEVEL) modules	
	cd linux-$(VERSION); make -j$(CONCURRENCY_LEVEL) INSTALL_MOD_PATH=../kernel_package modules_install
	cd kernel_package/lib/modules/*; unlink source; ln -s build source
	cd kernel_package/lib/modules/*; unlink build; ln -s /usr/src/linux-$(VERSION)-headers build

# Headers

kernel_package/usr/src/linux-$(VERSION)-headers: kernel_package/boot kernel_package/lib
	mkdir -p kernel_package/usr/src/linux-$(VERSION)-headers
	cp -a linux-$(VERSION)/.config kernel_package/usr/src/linux-$(VERSION)-headers/
	cp -a linux-$(VERSION)/Module.symvers kernel_package/usr/src/linux-$(VERSION)-headers/
	cp -a linux-$(VERSION)/Makefile kernel_package/usr/src/linux-$(VERSION)-headers/
	rsync --delete --archive linux-$(VERSION)/include/ kernel_package/usr/src/linux-$(VERSION)-headers/include
	rsync --delete --archive linux-$(VERSION)/scripts/ kernel_package/usr/src/linux-$(VERSION)-headers/scripts

	mkdir -p kernel_package/usr/src/linux-$(VERSION)-headers/arch/arm
	cp -a linux-$(VERSION)/arch/arm/Makefile kernel_package/usr/src/linux-$(VERSION)-headers/arch/arm/
	cp -a -R linux-$(VERSION)/arch/arm/include kernel_package/usr/src/linux-$(VERSION)-headers/arch/arm/
	rsync --delete --archive --include '*/' --include '*.h' --include 'Makefile' --include 'Module.symvers' --exclude '*' linux-$(VERSION)/arch/arm/mach-sunxi/ kernel_package/usr/src/linux-$(VERSION)-headers/arch/arm/mach-sunxi
#	rsync --delete --archive --include '*/' --include '*.h' --include 'Makefile' --include 'Module.symvers' --exclude '*' linux-$(VERSION)/arch/arm/plat-sunxi/ kernel_package/usr/src/linux-$(VERSION)-headers/arch/arm/plat-sunxi

#	cd linux-$(VERSION); make CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm HOSTCC=arm-linux-gnueabihf-gcc KBUILD_SCRIPTROOT=../../../../linux-$(VERSION) O=../kernel_package/usr/src/linux-$(VERSION)-headers/ -j1 scripts V=1

# Debian Package

linux-$(VERSION).deb: kernel_package/usr/src/linux-$(VERSION)-headers kernel_package/lib kernel_package/boot kernel_package/DEBIAN/control
	rm -f linux-$(VERSION).deb
	/sbin/depmod -b kernel_package/ $(FULLVERSION)
	fakeroot dpkg-deb -b kernel_package linux-$(VERSION).deb

tftp: linux-$(VERSION).deb
	echo 'put linux-$(VERSION)/arch/arm/boot/uImage uImage' | tftp 192.168.100.6
	echo 'put linux-$(VERSION)/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dtb olinuxino-a20.dtb' | tftp 192.168.100.6

install: linux-$(VERSION).deb
	scp linux-$(VERSION).deb root@192.168.100.30:linux-$(VERSION).deb
	ssh root@192.168.100.30 dpkg -i linux-$(VERSION).deb
