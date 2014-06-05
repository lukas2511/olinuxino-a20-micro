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

install:
	scp uboot.bin root@192.168.100.30:/tmp/uboot.bin
	ssh root@192.168.100.30 dd if=/tmp/uboot.bin of=/dev/mmcblk0 bs=1024 seek=8
