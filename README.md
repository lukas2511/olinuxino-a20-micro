olinuxino-a20-micro
===================

my build-tree for olinuxino-a20-micro stuff

 * kernel/ - contains makefiles to build a linux-sunxi.deb containing the linux-sunxi kernel, kernel headers and backported linuxtv media kernel extensions
 * kernel-mainline/ - contains makefiles to build a linux-sunxi-next.deb containing a kernel build from sunxi-next (soon-mainline) including kernel headers
 * sunxi-tools/ - contains makefiles to build sunxi-tools.deb containing the sunxi-tools like fex2bin etc.
 * uboot/ - contains makefiles to build uboot.bin (dd to microsd-card to use)
 * scriptfile/ - contains fexfile and related stuff
 * sdcard/ - contains buildscripts for sd-card images

### Easy-Build-Container Stuff

This requires [docker](http://www.docker.com)

 * emdebian/ - contains a Dockerfile describing a system that is able to build all of the above packages
 * emdebian/shell.sh - script to launch a shell in the emdebian container (usable for 'make menuconfig' or other tinkering)
 * */build.sh - script to use emdebian container to run "make"
