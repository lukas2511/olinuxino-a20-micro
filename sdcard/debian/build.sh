#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$(lsmod | grep binfmt_misc)" = "" ]; then
  echo For this script you need to have binfmt_misc loaded.
  exit 1
fi

docker run --privileged --rm -i -t -v "${DIR}"/../..:/root/build lukas2511/emdebian bash -c 'update-binfmts --enable qemu-arm; cd sdcard/debian; make || true; update-binfmts --disable qemu-arm'
