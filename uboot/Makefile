export ARCH              = arm
export SUBARCH           = armhf
export CROSS_COMPILE     = arm-linux-gnueabihf-
export CONCURRENCY_LEVEL = 10

all: uboot.bin uboot-next.bin

clean:
	cd u-boot-sunxi; git reset --hard; git clean -xfd
	cd u-boot-sunxi-next; git reset --hard; git clean -xfd

uboot.bin: u-boot-sunxi/u-boot-sunxi-with-spl.bin
	cp u-boot-sunxi/u-boot-sunxi-with-spl.bin uboot.bin

u-boot-sunxi/u-boot-sunxi-with-spl.bin:
	cd u-boot-sunxi; make A20-OLinuXino_MICRO_config
	cd u-boot-sunxi; make -j$(CONCURRENCY_LEVEL)

uboot-next.bin: u-boot-sunxi-next/u-boot-sunxi-with-spl.bin
	cp u-boot-sunxi-next/u-boot-sunxi-with-spl.bin uboot-next.bin

u-boot-sunxi-next/u-boot-sunxi-with-spl.bin:
	cd u-boot-sunxi-next; make A20-OLinuXino_MICRO_config
	cd u-boot-sunxi-next; make -j$(CONCURRENCY_LEVEL)
