FROM debian:7.3

# Add emdebian repository and keyring
RUN echo deb http://www.emdebian.org/debian unstable main > /etc/apt/sources.list.d/emdebian.list
RUN apt-get update
RUN apt-get install --force-yes -y emdebian-archive-keyring
RUN apt-get update

# Install basic tools
RUN apt-get install -y curl sudo wget bc rsync

# Install build tools
RUN apt-get install -y build-essential ncurses-dev kmod libproc-processtable-perl uboot-mkimage

# Install emdebian toolchain
RUN apt-get install gcc-4.7-arm-linux-gnueabihf 
RUN ln -s /usr/bin/arm-linux-gnueabihf-gcc-4.7 /usr/bin/arm-linux-gnueabihf-gcc

VOLUME ["/root/build"]

ENV HOME /root
WORKDIR /root/build

CMD ["bash"]

