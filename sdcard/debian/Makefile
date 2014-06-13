all: debian.img

debian.img:
	cd ../../kernel; make linux-sunxi.deb
	cd ../../uboot; make uboot.bin
	cd ../../scriptfile; make olinuxino-a20-micro-fexfile.deb
	cd ../../sunxi-tools; make sunxi-tools.deb
	make rootfs
	dd if=/dev/zero of=debian.img bs=10M count=100
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
	debootstrap --arch=armhf --foreign wheezy rootfs_cache http://ftp.de.debian.org/debian
	cp /usr/bin/qemu-arm-static rootfs_cache/usr/bin
	chroot rootfs_cache /debootstrap/debootstrap --second-stage
	cat sources.list > rootfs_cache/etc/apt/sources.list
	chroot rootfs_cache apt-get update
	chroot rootfs_cache apt-get upgrade -y
	chroot rootfs apt-get install locales openssh-server -d -y

rootfs: rootfs_cache ../../kernel/linux-sunxi.deb
	rsync --archive --delete rootfs_cache/ rootfs
	chroot rootfs apt-get install locales -y
	echo 'en_US.UTF-8 UTF-8' > rootfs/etc/locale.gen
	chroot rootfs locale-gen
	chroot rootfs apt-get install openssh-server -y
	chroot rootfs /etc/init.d/ssh stop
	cat network_interfaces > rootfs/etc/network/interfaces
	cp ../../kernel/linux-sunxi.deb rootfs/linux-sunxi.deb
	chroot rootfs dpkg -i /linux-sunxi.deb
	rm rootfs/linux-sunxi.deb
	cp ../../scriptfile/olinuxino-a20-micro-fexfile.deb rootfs/olinuxino-a20-micro-fexfile.deb
	chroot rootfs dpkg -i /olinuxino-a20-micro-fexfile.deb
	rm rootfs/olinuxino-a20-micro-fexfile.deb
	cp ../../sunxi-tools/sunxi-tools.deb rootfs/sunxi-tools.deb
	chroot rootfs dpkg -i /sunxi-tools.deb
	rm rootfs/sunxi-tools.deb
	echo 'T0:23:respawn:/sbin/getty -L ttyS0 115200 vt100' >> rootfs/etc/inittab
	sed -i 's/root:\*/root:4TL.6CCyuNsMQ/' rootfs/etc/shadow
	echo olinuxino > rootfs/etc/hostname
