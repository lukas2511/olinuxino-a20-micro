all: debian.img

debian.img:
	cd ../../kernel; make linux-sunxi.deb
	cd ../../uboot; make uboot.bin
	cd ../../scriptfile; make olinuxino-a20-micro-fexfile.deb
	cd ../../sunxi-tools; make sunxi-tools.deb
	make rootfs
	dd if=/dev/zero of=debian.img bs=10M count=50
	echo -e 'o \n n \n p \n \n \n \n w \n' | fdisk debian.img
	losetup /dev/loop0 2> /dev/null && losetup -d /dev/loop0 || true
	losetup --offset 1048576 /dev/loop0 debian.img
	mkfs.ext4 /dev/loop0
	umount -l /mnt 2> /dev/null || true
	mount /dev/loop0 /mnt
	rmdir /mnt/lost+found
	rsync --archive rootfs/ /mnt/
	sync
	umount /mnt
	losetup -d /dev/loop0
	dd if=../../uboot/uboot.bin of=debian.img bs=1024 seek=8 conv=notrunc

rootfs_cache:
	if [ -d "rootfs_cache/sys/fs" ]; then umount rootfs_cache/sys; fi
	if [ -d "rootfs_cache/proc/sys" ]; then umount rootfs_cache/proc; fi
	debootstrap --arch=armhf --variant=proot --foreign wheezy rootfs_cache http://ftp.de.debian.org/debian
	cp /usr/bin/qemu-arm-static rootfs_cache/usr/bin
	proot -r rootfs_cache -w / -q qemu-arm-static /debootstrap/debootstrap --second-stage
	cat stuff/sources.list > rootfs_cache/etc/apt/sources.list
	proot -r rootfs_cache -w / -q qemu-arm-static apt-get update
	proot -r rootfs_cache -w / -q qemu-arm-static apt-get upgrade -y
	proot -r rootfs_cache -w / -q qemu-arm-static apt-get install locales openssh-server -d -y

rootfs: rootfs_cache ../../kernel/linux-sunxi.deb
	rsync --archive --delete rootfs_cache/ rootfs
	proot -r rootfs -w / -q qemu-arm-static apt-get install locales -y
	echo 'en_US.UTF-8 UTF-8' > rootfs/etc/locale.gen
	proot -r rootfs -w / -q qemu-arm-static locale-gen
	mkdir rootfs/etc/ssh
	cp stuff/dummy_keys/* rootfs/etc/ssh/
	chmod 600 stuff/dummy_keys/*
	chmod 755 stuff/dummy_keys/*.pub
	mv rootfs/usr/sbin/invoke-rc.d rootfs/usr/sbin/invoke-rc.d.orig
	cp stuff/i_hate_debian.sh rootfs/usr/sbin/invoke-rc.d
	chmod a+x rootfs/usr/sbin/invoke-rc.d
	proot -r rootfs -w / -q qemu-arm-static apt-get install openssh-server -y
	mv rootfs/usr/sbin/invoke-rc.d.orig rootfs/usr/sbin/invoke-rc.d
	proot -r rootfs -w / -q qemu-arm-static /etc/init.d/ssh stop
	cat stuff/network_interfaces > rootfs/etc/network/interfaces
	cp ../../kernel/linux-sunxi.deb rootfs/linux-sunxi.deb
	proot -r rootfs -w / -q qemu-arm-static dpkg -i /linux-sunxi.deb
	rm rootfs/linux-sunxi.deb
	cp ../../scriptfile/olinuxino-a20-micro-fexfile.deb rootfs/olinuxino-a20-micro-fexfile.deb
	proot -r rootfs -w / -q qemu-arm-static dpkg -i /olinuxino-a20-micro-fexfile.deb
	rm rootfs/olinuxino-a20-micro-fexfile.deb
	cp ../../sunxi-tools/sunxi-tools.deb rootfs/sunxi-tools.deb
	proot -r rootfs -w / -q qemu-arm-static dpkg -i /sunxi-tools.deb
	rm rootfs/sunxi-tools.deb
	echo 'T0:23:respawn:/sbin/getty -L ttyS0 115200 vt100' >> rootfs/etc/inittab
	sed -i 's/root:\*/root:4TL.6CCyuNsMQ/' rootfs/etc/shadow
	echo olinuxino > rootfs/etc/hostname
	cp stuff/olinuxino_setup.sh rootfs/usr/sbin/olinuxino_setup.sh
	chmod a+x rootfs/usr/sbin/olinuxino_setup.sh
	cp stuff/rc.local rootfs/etc/rc.local
	chmod a+x rootfs/etc/rc.local
	touch rootfs/etc/.firstboot
	proot -r rootfs -w / -q qemu-arm-static apt-get clean
	cat stuff/fstab > rootfs/etc/fstab
