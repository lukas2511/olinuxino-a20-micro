export ARCH              = arm
export SUBARCH           = armhf
export CROSS_COMPILE     = arm-linux-gnueabihf-
export CONCURRENCY_LEVEL = 10
export PATH             := /opt/arm-linux-gnueabihf/:$(PATH)
export DEB_HOST_ARCH     = $(SUBARCH)

all: clean kernel linux-uimage.deb

linux-sunxi/.config: config
	cp config linux-sunxi/.config

clean:
	rm -f uimage_package/boot/uImage
	rm -f *.deb
	cd linux-sunxi; git reset --hard; git clean -fxd

kernel: linux-sunxi/.config
	cd linux-sunxi; rm -rf debian
	cd linux-sunxi; fakeroot make-kpkg --arch $(ARCH) --subarch $(SUBARCH) --cross-compile $(CROSS_COMPILE) kernel_image kernel_headers

linux-sunxi/arch/arm/boot/uImage:
	cd linux-sunxi; make -j$(CONCURRENCY_LEVEL) uImage

linux-uimage.deb: linux-sunxi/arch/arm/boot/uImage
	cp linux-sunxi/arch/arm/boot/uImage uimage_package/boot/uImage
	fakeroot dpkg-deb -b uimage_package linux-uimage.deb

menuconfig: clean linux-sunxi/.config
	cd linux-sunxi; make menuconfig
	cp linux-sunxi/.config config
