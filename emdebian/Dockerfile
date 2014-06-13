FROM debian:7.3

# Add emdebian repository and keyring
RUN echo deb http://www.emdebian.org/debian unstable main > /etc/apt/sources.list.d/emdebian.list
RUN apt-get update
RUN apt-get install --force-yes -y emdebian-archive-keyring
RUN apt-get update

# Install basic tools
RUN apt-get install -y curl sudo wget bc rsync git

# Install build tools
RUN apt-get install -y build-essential ncurses-dev kmod libproc-processtable-perl uboot-mkimage

# Install emdebian toolchain
RUN apt-get install -y gcc-4.7-arm-linux-gnueabihf 
RUN ln -s /usr/bin/arm-linux-gnueabihf-gcc-4.7 /usr/bin/arm-linux-gnueabihf-gcc

# Install libusb headers and pkg-config
RUN apt-get install -y pkg-config libusb-1.0-0-dev

# Install debootstrap and qemu-utils
RUN apt-get install -y debootstrap qemu-utils

# Install qemu-user-static
RUN apt-get install -y qemu-user-static

# Install proot
ADD http://static.proot.me/proot-x86_64 /usr/bin/proot
RUN chmod a+x /usr/bin/proot

# Install patched debootstrap
ADD ./debootstrap.deb /root/debootstrap.deb
RUN dpkg -i /root/debootstrap.deb
RUN rm /root/debootstrap.deb

VOLUME ["/root/build"]

ENV HOME /root
WORKDIR /root/build

CMD ["bash"]

