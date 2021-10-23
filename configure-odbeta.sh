#! /bin/sh

export PATH=/opt/opendingux-toolchain/usr/bin:$PATH
export PATH=`mipsel-gcw0-linux-uclibc-gcc --print-sysroot`/bin:$PATH 
CC=mipsel-gcw0-linux-uclibc-gcc CFLAGS="-O2 -DOD_BETA=1 -fomit-frame-pointer -ffunction-sections -ffast-math" ./configure --target-device=gcw0 --disable=notify-frontend --disable=log-frontend
