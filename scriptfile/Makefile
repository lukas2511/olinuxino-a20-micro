all: olinuxino-a20-micro-fexfile.deb

../sunxi-tools/sunxi-tools/fexc:
	cd ../sunxi-tools/sunxi-tools/; make

decompile: ../sunxi-tools/sunxi-tools/fexc
	../sunxi-tools/sunxi-tools/bin2fex script.bin > script.fex

script.bin: ../sunxi-tools/sunxi-tools/fexc script.fex
	../sunxi-tools/sunxi-tools/fex2bin script.fex > script.bin

debian_package/boot/script.bin: script.bin
	mkdir -p debian_package/boot
	cp -a script.bin debian_package/boot/script.bin

olinuxino-a20-micro-fexfile.deb: debian_package/boot/script.bin
	rm -f olinuxino-a20-micro-fexfile.deb
	dpkg-deb -b debian_package olinuxino-a20-micro-fexfile.deb
