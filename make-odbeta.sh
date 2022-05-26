#! /bin/sh

export PATH=/opt/opendingux-toolchain/usr/bin:$PATH
export PATH=`mipsel-gcw0-linux-uclibc-gcc --print-sysroot`/bin:$PATH 
make STRIP=mipsel-gcw0-linux-uclibc-strip DISTFILES="gmu.bin frontends decoders themes gmu.png README.txt libs.gcw0 COPYING gmu.bmp htdocs gmu-gcw0.dge gmuinput.gcw0.conf default.gcw0.desktop gmu.rg350.conf gmu.rg350m.conf gmuinput.rg350.conf rg350.keymap" -j`nproc` distbin
