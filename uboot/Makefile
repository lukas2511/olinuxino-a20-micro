export ARCH              = arm
export SUBARCH           = armhf
export CROSS_COMPILE     = arm-linux-gnueabihf-
export CONCURRENCY_LEVEL = 10

all: uboot.bin

clean:
	cd u-boot-sunxi; git reset --hard; git clean -xfd

uboot.bin: u-boot-sunxi/u-boot-sunxi-with-spl.bin
	cp u-boot-sunxi/u-boot-sunxi-with-spl.bin uboot.bin

u-boot-sunxi/u-boot-sunxi-with-spl.bin:
	cd u-boot-sunxi; make A20-OLinuXino_MICRO_config
	cd u-boot-sunxi; make -j$(CONCURRENCY_LEVEL)
