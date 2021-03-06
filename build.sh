#!/bin/bash

function install_build_tools {
  sudo apt-get install git
	sudo apt-get install libasound2-dev
	sudo apt-get install build-essential
	sudo apt-get install make
	sudo apt-get install autoconf
	sudo apt-get install libtool
	sudo apt-get install nginx
	sudo apt-get install -qy libomxil-bellagio-dev
  sudo sh -c 'echo "deb http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list.d/deb-multimedia.list'
  sudo sh -c 'echo "deb-src http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list.d/deb-multimedia.list'
  sudo apt-get update
  sudo apt-get install deb-multimedia-keyring
  sudo apt-get update
  sudo apt-get remove ffmpeg
  sudo apt-get install build-essential libmp3lame-dev libvorbis-dev libtheora-dev libspeex-dev yasm pkg-config libfaac-dev libopenjpeg-dev libx264-dev
}

function build_h264 {
    # h.264 video encoder

    echo "Building h264"

    cd /usr/src/app
    git clone git://git.videolan.org/x264
    cd x264

    ./configure --host=arm-unknown-linux-gnueabi --enable-static --disable-opencl
    make
    make install
}

function build_lame {
    # mp3 audio encoder

	echo "Building lame"

    cd /usr/src/app
    wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.tar.gz
    tar xzvf lame-3.99.tar.gz
    cd lame-3.99
    ./configure
    make
    make install
}

function build_faac {
    # aac encoder

    echo "Building faac"

    cd /usr/src/app
    curl -#LO http://downloads.sourceforge.net/project/faac/faac-src/faac-1.28/faac-1.28.tar.gz
    tar xzvf faac-1.28.tar.gz
    cd faac-1.28
    ./configure
    make
    make install
}

function build_ffmpeg {

	echo "Building ffmpeg"

    cd /usr/src/app/
    sudo git clone https://github.com/FFmpeg/FFmpeg.git
    cd FFmpeg/
    sudo ./configure --arch=armel --target-os=linux --enable-gpl --enable-omx --enable-omx-rpi --enable-nonfree
    # sudo ./configure --prefix=/usr --arch=armel --target-os=linux --enable-gpl --enable-omx --enable-omx-rpi --enable-nonfree --enable-libx264 --enable-version3 --disable-mmx
    sudo make -j4
    sudo make install
}

function configure_ldconfig {

	echo "Building ldconfig"

    echo "/usr/local/lib" > /etc/ld.so.conf.d/libx264.conf
    ldconfig
}

function build_psips {
  git clone git://github.com/AndyA/psips.git
  cd psips
  ./setup.sh && ./configure && make && make install
}

install_build_tools
# build_yasm
build_h264
# build_lame
# build_faac
# build_ffmpeg
# configure_ldconfig
# build_psips
