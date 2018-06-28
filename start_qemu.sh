#!/bin/bash
#DRIVE="-drive format=raw,file=buildroot/output/images/project.hdimg"
DRIVE="-drive id=disk,file=buildroot/output/images/project.hdimg,if=none -device ahci,id=ahci -device ide-drive,drive=disk,bus=ahci.0"
# tmpfs needs a minimum of 256M for swupdate uncompresed file hosting
RAM="-m 512M"
qemu-system-x86_64 -curses ${DRIVE} ${RAM} -net user,hostfwd=tcp::8080-:80,hostfwd=tcp::2222-:22 -net nic
