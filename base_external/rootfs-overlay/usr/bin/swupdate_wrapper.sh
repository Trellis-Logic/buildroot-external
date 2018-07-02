#!/bin/sh
set -e
scriptdir=`dirname $0`
. ${scriptdir}/swupdate_find_root_config.sh /etc/swupdate/swupdate_rootdef.conf
otherargs="$@"
echo "running swupdate -e stable,${swupdate_swconfig_rootfs} ${otherargs}"
swupdate -e stable,${swupdate_swconfig_rootfs} ${otherargs}
