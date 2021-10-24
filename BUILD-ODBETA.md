## GMU fo mainline OpenDingux (current beta)

Thanks to [Johannes Heimansberg](http://wej.k.vu/projects/gmu/) for this great piece of software

The GCW0 changes included here are borrowed from [Denis N Kuznetsov gcw0 port](https://github.com/denis-n-kuznetsov/gmu) (thank you!)

Latest build for OpenDingux can be obtained [here](http://od.abstraction.se/opendingux/latest/)

## How to build

With the current OpenDingux toolchain these are the out-of-the-box enabled decoders list:

- Opus
- mpg123
- Vorbis
- FLAC
- Speex
- ModPlug

WavPack can be built and included as library


### OpenDingux Toolchain

You need the OpenDingux toolchain installed to build gmu.

You have two options:

- Download the toolchain from [here](http://od.abstraction.se/opendingux/toolchain/) and extract it to a local directory 
- Build your own toolchain:

    - Clone the [OpenDingux buildroot git repo](`https://github.com/OpenDingux/buildroot`)
    - Execute the script `CONFIG=gcw0 ./rebuild.sh` in the directory where you have just cloned it.
    - When the build is finished the toolchain will be created in the `output/gcw0/images` folder as a `opendingux-gcw0-toolchain.AAAA-MM-DD.tar.xz` file. Extract it to a local directory

In both cases go to the directory where you have extracted the toolchain and relocate it executing `./relocate-sdk.sh`


### Build with the scripts provided

_See sections below for details about how to build manually withouth the scripts._

The shell scripts **`build-wavpack.sh`**, **`configure-odbeta.sh`** and **`makefile-odbeta.sh`** do all the commands needed to build gmu for current OpenDingux. This include the download and build of WavPack library. 

These scripts use `/opt/opendingux` as default path for the toolchain, so you must adjust them to where your toolchain is located.

Execute the scripts with regular user in your gmu folder in this order:

    ./build-wavpack.sh
    ./configure-odbeta.sh
    ./make-odbeta.sh

> WavPack 5.4.0 is currently used in the scrip `build-wavpack.sh`.


### Build manually

From here I will use `/opt/opendingux-toolchain` as toolchain path. Adjust it to where yout toolchain is installed.

Open a terminal in your gmu sources folder and do not close until build gmu.

Put your toolchain in PATH:

    export PATH=/opt/opendingux-toolchain/usr/bin:$PATH

Also we need toolchain sysroot in PATH for `sdl-config`:

    export PATH=`mipsel-gcw0-linux-uclibc-gcc --print-sysroot`/bin:$PATH 

#### WavPack build

WavPack is not included in current OpenDingux so we have to build and include as ahared library with our gmu build.

To build it first download *nix sources from [WavPack downloads page](https://www.wavpack.com/downloads.html#sources)

Then uncompress the downloaded file in a folder named `wavpack` into your gmu sources folder. This will be necesary for gmu build.

You can do it executing the next commands:

    wget https://www.wavpack.com/wavpack-5.4.0.tar.xz
    mkdir -p wavpack && tar -C wavpack -xvJf wavpack-5.4.0.tar.xz --strip-components 1

> `wavpack-5.4.0.tar.xz` is the version available at the time I write this. Go [here](https://www.wavpack.com/downloads.html) to see current available version.

Now enter in the `wavpack` folder and compile it:

    cd wavpack
    ./configure --disable-asm --enable-rpath --disable-tests --disable-apps --disable-dsd --enable-legacy --disable-static --host=mipsel-gcw0-linux-uclibc

Go back to the gmu folder and copy the newly built wavpack shared library to the `libs.gcw0` folder as` libwavpack.so.1`. Create the `libs.gcw0` folder if it does not exist.

    cd ..
    mkdir -p libs.gcw0
    cp ./wavpack/src/.libs/libwavpack.so.1.2.3 ./libs.gcw0/libwavpack.so.1

> With current wavpack version the shared library built is `libwavpack.so.1.2.3`. This may change if you use a diferent version of WavPack.


#### GMU build

Configure gmu to create the specific `config.mk` for our device.

    CC=mipsel-gcw0-linux-uclibc-gcc CFLAGS="-O2 -DOD_BETA=1 -fomit-frame-pointer -ffunction-sections -ffast-math" ./configure --target-device=gcw0 --disable=notify-frontend --disable=log-frontend --enable=wavpack-decoder --includes=wavpack/include --libs=wavpack/src/.libs

>- Compiler and flags to be used are selected via the `CC` and `CFLAGS` environment variables.
>- `OD_BETA` definition is needed for WavPack build. 
>- Select gcw0 target with `--target-device=gcw0` and disable some frontends with `-disable=notify-frontend --disable=log-frontend`
>- Enable WavPack build and set where includes and libs are located with `--enable=wavpack-decoder --includes=wavpack/include --libs=wavpack/src/.libs`


Now we build for this configuration:

    make STRIP=mipsel-gcw0-linux-uclibc-strip DISTFILES="gmu.bin frontends decoders themes gmu.png README.txt libs.gcw0 COPYING gmu.bmp htdocs gmu-gcw0.dge gmuinput.gcw0.conf default.gcw0.desktop gmu.rg350.conf gmuinput.rg350.conf rg350.keymap" -j`nproc` distbin

>- Strip program to use is selected passing `STRIP` variable to the make command.
>- The distfiles to include in the opk file to be generated is passed in `DISTFILES` variable.
>     - The files to include must exist previously or must be generated with the build.
>     - `gmu-gcw0.dge` is the shell script that select the config file to be used, it stablish the external libs location to use and launch `gmu.bin`
>     - `gmu.rg350.conf`, `gmuinput.rg350.conf` and `rg350.keymap` are the specific configurations used for anbernic devices.

If all went well, an opk file will be generated in your gmu folder.
