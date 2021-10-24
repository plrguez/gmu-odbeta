#! /bin/sh

rm -rf wavpack
rm wavpack-5.4.0.tar.xz
rm ./libs.gcw0/libwavpack.so*
wget https://www.wavpack.com/wavpack-5.4.0.tar.xz
mkdir -p wavpack && tar -C wavpack -xvJf wavpack-5.4.0.tar.xz --strip-components 1
cd wavpack
export PATH=/opt/opendingux-toolchain/usr/bin:$PATH
./configure --disable-asm --enable-rpath --disable-tests --disable-apps --disable-dsd --enable-legacy --disable-static --host=mipsel-gcw0-linux-uclibc
make -j4
cd ..
mkdir -p libs.gcw0
cp ./wavpack/src/.libs/libwavpack.so.1.2.3 ./libs.gcw0/libwavpack.so.1
