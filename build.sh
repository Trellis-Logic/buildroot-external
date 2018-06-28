#!/bin/bash

. ./setup_external.sh
BUILDROOT_DIR=buildroot
# This is the configuration from EXTERNAL_DIR_BR_RELATIVE which will be used as defconfig when .config is missing
DEFCONFIG_EXTERNAL=configs/x86_64_qemu_defconfig
HOST_CORES=1
HOST_CORES=`grep -c ^processor /proc/cpuinfo`

if [ -z ${HOST_CORES} ]; then
    echo "Couldn't determine host core count, using 1"
    HOST_CORES=1
else
    echo "Using auto detected parallel build host cores=${HOST_CORES}"
fi


git submodule init
git submodule sync
git submodule update
set -e
if [ ! -e ${BUILDROOT_DIR}/.config ]; then
    echo "Missing buildroot configuration, using defconfig from ${EXTERNAL_DIR_BR_RELATIVE}"
    make -C ${BUILDROOT_DIR} defconfig BR2_EXTERNAL=${EXTERNAL_DIR_BR_RELATIVE_LIST} BR2_DEFCONFIG=${EXTERNAL_DIR_BR_RELATIVE}/${DEFCONFIG_EXTERNAL}
else
    echo "Using existing buildroot config.  To force update, delete ${BUILDROOT_DIR}/.config"
fi

echo "Building using external directories in list ${EXTERNAL_DIR_BR_RELATIVE_LIST}"
make ${EXTRA_BUILDROOT_OPTIONS} BR2_JLEVEL=${HOST_CORES} -C ${BUILDROOT_DIR} BR2_EXTERNAL=${EXTERNAL_DIR_BR_RELATIVE_LIST}
