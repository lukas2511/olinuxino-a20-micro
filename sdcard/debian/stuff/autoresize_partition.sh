#!/bin/bash

if [ -f "/etc/.firstboot" ]; then
  echo -e 'd \n n \n p \n 1 \n 2048 \n \n w \n' | fdisk /dev/mmcblk0
  rm /etc/.firstboot
  touch /etc/.secondboot
  reboot
  exit 0
fi

if [ -f "/etc/.secondboot" ]; then
  resize2fs /dev/mmcblk0p1
  rm /etc/.secondboot
  reboot
  exit 0
fi
