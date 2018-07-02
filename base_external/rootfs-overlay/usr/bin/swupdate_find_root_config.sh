#!/bin/sh
set -e
printusage() {
	echo "Usage: $0 <rootfsfile>"
	echo "Where rootfsfile contains definitions of variables rootfsa and rootfsb which define"
	echo "possible root device partuuid corresponding to associated rootfs boot locations"
}

non_match_config=
# sets non_match_config global with the config parameter passed as the first argument
# if the partuuid at the second arg doesn't match the PARTUUID parameter in the cmd arg
checkdevstring() {
	config=$1
	partuuid=$2
	set +e
	cat /proc/cmdline | grep "PARTUUID=$partuuid" > /dev/null
	result=$?
	set +e
	if [ $result -eq 0 ]; then
		echo "Found match for root device in partuuid $device"
	else
		if [ -z "$non_match_config" ]; then
			echo "Partuuid $partuuid is not a root device, using config $config"
			non_match_config=$config
		else
			echo "Found two not matching root devs, this should not be possible, exiting"
			exit 1
		fi
	fi
}

if [ $# -ne 1 ]; then
	echo "Missing required rootfs config file argument"
	printusage()
	exit 1
fi

rootfsconfig=$1
if [ ! -r $rootfsconfig ]; then
	echo "File at $rootfsconfig is not readable"
	printusage()
	exit 1
fi

. $rootfsconfig

if [ -z "${rootfsa}" ] || [ -z "${rootfsb}" ]; then
	echo "Missing root definitions in $rootfsconfig"
	printusage()
	exit 1
fi

checkdevstring rootfsa ${rootfsa}
checkdevstring rootfsb ${rootfsb}

if [ -z "$non_match_config" ]; then
	echo "Didn't find a device not matching the root device, can't continue"
	exit 1
fi
export swupdate_swconfig_rootfs=$non_match_config
echo "Using swupdate_swconfig_rootfs ${swupdate_swconfig_rootfs}"

