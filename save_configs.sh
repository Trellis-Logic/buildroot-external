#!/bin/bash
# TODO: add all other configuration save commands here for any other modified configs
. ./setup_external.sh
make -C buildroot savedefconfig BR2_DEFCONFIG=../${EXTERNAL_DIR}/configs/x86_64_qemu_defconfig
make -C buildroot linux-update-defconfig
make -C buildroot swupdate-update-defconfig
