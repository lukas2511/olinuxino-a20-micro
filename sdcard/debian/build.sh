#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run --rm -i -t -v "${DIR}"/../..:/root/build lukas2511/emdebian bash -c 'cd sdcard/debian; make'
