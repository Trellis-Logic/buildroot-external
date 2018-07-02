#!/bin/bash
printusage() {
    echo "$0 <partuuid>"
    echo "where partuuid is specified in hex characters without a leading 0x"
}
set -e
if [ $# -eq 0 ]; then
    printusage
    exit 1
fi
partuuid=$1
# ensure partuuid is lowercase for udev revferences
partuuid=`echo ${partuuid} | sed -e 's/\(.*\)/\L\1/'`
sed -i "s/disk-signature = 0x[0-9,A-F,a-f]\+/disk-signature = 0x${partuuid}/g" base_external/configs/genimage.cfg 
sed -i "s/SWUPDATE_PARTUUID_BOOT_DEV=\"[0-9,A-F,a-f]\+/SWUPDATE_PARTUUID_BOOT_DEV=\"${partuuid}/g" base_external/scripts/build-swupdate-swu.sh
sed -i "s/PARTUUID=[0-9,A-F,a-f]\+/PARTUUID=${partuuid}/g" base_external/rootfs-overlay/boot/grub/grub.cfg
sed -i "s/by-partuuid\/[0-9,A-F,a-f]\+/by-partuuid\/${partuuid}/g" base_external/rootfs-overlay/etc/fstab
sed -i "s/\(rootfs[a,b]=\"\)[0-9,A-F,a-f]\+/\1${partuuid}/g" base_external/rootfs-overlay/etc/swupdate/swupdate_rootdef.conf
