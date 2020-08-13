#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS ####

do_step ${APT} remove wsjtx # nuke 2.1.2 from the repos

# this worked 2020-08-12 after an apt-get update and apt-get upgrade

do_step ${APT} install -y build-essential gfortran autoconf automake libtool cmake git
do_step ${APT} install -y asciidoctor libfftw3-dev qtdeclarative5-dev texinfo libqt5multimedia5 libqt5multimedia5-plugins qtmultimedia5-dev libusb-dev libqt5serialport5-dev asciidoc libudev-dev
do_step ${APT} install qttools5-dev
do_step ${APT} install libusb-1.0-0-dev
do_step mkdir -p wsjtx_build/hamlib
do_step git clone git://git.code.sf.net/u/bsomervi/hamlib wsjtx_build/hamlib/src
do_step bash -c "cd wsjtx_build/hamlib/src && git checkout integration"
do_step bash -c "cd wsjtx_build/hamlib/src && ./bootstrap" 
do_step mkdir wsjtx_build/hamlib/build
do_step bash -c "cd wsjtx_build/hamlib/build && ../src/configure --prefix=$HOME/hamlib-prefix    --disable-shared --enable-static    --without-cxx-binding --disable-winradio    CFLAGS='-g -O2 -fdata-sections -ffunction-sections'  LDFLAGS='-Wl,--gc-sections'"
do_step bash -c "cd wsjtx_build/hamlib/build && make -j4"
do_step bash -c "cd wsjtx_build/hamlib/build && make install-strip"
do_step mkdir wsjtx_build/wsjtx
do_step bash -c "cd wsjtx_build/wsjtx && git clone https://git.code.sf.net/p/wsjt/wsjtx wsjt-wsjtx"
do_step mkdir wsjtx_build/wsjtx/build
do_step mkdir wsjtx_build/wsjtx/output
do_step bash -c "cd wsjtx_build/wsjtx/build && cmake -D CMAKE_PREFIX_PATH=~/hamlib-prefix -D CMAKE_INSTALL_PREFIX=~/wsjtx/output ../wsjt-wsjtx/"
do_step bash -c "cd wsjtx_build/wsjtx/build && cmake --build . -- -j4 "
do_step bash -c "cd wsjtx_build/wsjtx/build && cmake --build . --target install"
do_step mv /root/wsjtx /usr/local/
do_step ln -s /usr/local/wsjtx/output/bin/wsjtx /usr/local/bin/wsjtx
do_step rm -r wsjtx_build
