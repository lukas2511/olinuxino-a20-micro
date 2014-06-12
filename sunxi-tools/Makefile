all: sunxi-tools.deb

CC=arm-linux-gnueabihf-gcc

sunxi-tools/.git:
	cd ..; \
	git submodule init; \
	git submodule update

debian_package/usr/bin:
	mkdir -p debian_package/usr/bin

debian_package/usr/bin/fexc: sunxi-tools/fexc.c
	cd sunxi-tools; $(CC) -g -O0 -Wall -Wextra -std=c99 -D_POSIX_C_SOURCE=200112L -Iinclude/  -o fexc fexc.c script.c script_uboot.c script_bin.c script_fex.c
	cp -a sunxi-tools/fexc debian_package/usr/bin/fexc
	cd debian_package/usr/bin; ln -s fexc bin2fex
	cd debian_package/usr/bin; ln -s fexc fex2bin

debian_package/usr/bin/bootinfo: sunxi-tools/bootinfo.c
	cd sunxi-tools; $(CC) -g -O0 -Wall -Wextra -std=c99 -D_POSIX_C_SOURCE=200112L -Iinclude/  -o bootinfo bootinfo.c
	cp -a sunxi-tools/bootinfo debian_package/usr/bin/bootinfo

debian_package/usr/bin/pio: sunxi-tools/pio.c
	cd sunxi-tools; $(CC) -g -O0 -Wall -Wextra -std=c99 -D_POSIX_C_SOURCE=200112L -Iinclude/  -o pio pio.c
	cp -a sunxi-tools/pio debian_package/usr/bin/pio

debian_package/usr/bin/nand-part: sunxi-tools/nand-part-main.c
	cd sunxi-tools; $(CC) -g -O0 -Wall -Wextra -std=c99 -D_POSIX_C_SOURCE=200112L -Iinclude/ -c -o nand-part-main.o nand-part-main.c
	cd sunxi-tools; $(CC) -g -O0 -Wall -Wextra -std=c99 -D_POSIX_C_SOURCE=200112L -Iinclude/ -c -o nand-part-a10.o nand-part.c -D A10
	cd sunxi-tools; $(CC) -g -O0 -Wall -Wextra -std=c99 -D_POSIX_C_SOURCE=200112L -Iinclude/ -c -o nand-part-a20.o nand-part.c -D A20
	cd sunxi-tools; $(CC) -o nand-part nand-part-main.o nand-part-a10.o nand-part-a20.o
	cp -a sunxi-tools/nand-part debian_package/usr/bin/nand-part

sunxi-tools.deb: debian_package/usr/bin debian_package/usr/bin/fexc debian_package/usr/bin/bootinfo debian_package/usr/bin/pio debian_package/usr/bin/nand-part
	rm -f sunxi-tools.deb
	fakeroot dpkg-deb -b debian_package sunxi-tools.deb
