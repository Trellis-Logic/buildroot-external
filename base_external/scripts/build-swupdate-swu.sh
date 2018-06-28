SWUPDATE_VERSION="0.0.0"
SWUPDATE_DESCRIPTION="Firmware update for Test project"
SWUPDATE_ROOT_FILENAME_BASE="rootfs.ext2"
SWUPDATE_IMAGES_DIR=${BINARIES_DIR}
SWUPDATE_PARTUUID_BOOT_DEV="544c4f47"
SWUPDATE_PARTUUID_ROOTFSA_PART="01"
SWUPDATE_PARTUUID_ROOTFSB_PART="02"
SWUPDATE_ROOT_FILE_COMPRESSED="false"
SWUPDATE_STAGING_DIR=${STAGING_DIR}/swupdate
GRUB_EDITENV_BIN=${HOST_DIR}/bin/grub-editenv
GRUB_ENV_PATH=${BASE_DIR}/data-partition/boot/grub/grubenv
SWUPDATE_PRODUCT_NAME="project"
set -e
if [ ${SWUPDATE_ROOT_FILE_COMPRESSED} = "true" ]; then
    rm -f ${SWUPDATE_ROOT_FILE}
    SWUPDATE_ROOT_FILENAME="${SWUPDATE_ROOT_FILENAME_BASE}.gz2"
    SWUPDATE_ROOT_FILE=${SWUPDATE_IMAGES_DIR}/${SWUPDATE_ROOT_FILENAME}
    tar -C ${SWUPDATE_IMAGES_DIR} -zcvf ${SWUPDATE_ROOT_FILE} ${SWUPDATE_ROOT_FILENAME_BASE}
else
    SWUPDATE_ROOT_FILENAME=${SWUPDATE_ROOT_FILENAME_BASE}
    SWUPDATE_ROOT_FILE=${SWUPDATE_IMAGES_DIR}/${SWUPDATE_ROOT_FILENAME}
fi
mkdir -p ${SWUPDATE_STAGING_DIR}
# See https://sbabic.github.io/swupdate/sw-description.html#software-collections
cat << EOF > ${SWUPDATE_STAGING_DIR}/sw-description
software =
{
    version = "${SWUPDATE_VERSION}";
    description = "${SWUPDATE_DESCRIPTION}";

    stable = {
        rootfsa: {
            images: (
                    {
                        filename = "${SWUPDATE_ROOT_FILENAME}";
                        device = "/dev/disk/by-partuuid/${SWUPDATE_PARTUUID_BOOT_DEV}-${SWUPDATE_PARTUUID_ROOTFSA_PART}";
                        compressed = ${SWUPDATE_ROOT_FILE_COMPRESSED};
                    }
             );
             bootenv: (
                    {
                        name = "default";
                        value = "0";
                    }
            );
        }
        rootfsb: {
            images: (
                    {
                        filename = "${SWUPDATE_ROOT_FILENAME}";
                        device = "/dev/disk/by-partuuid/${SWUPDATE_PARTUUID_BOOT_DEV}-${SWUPDATE_PARTUUID_ROOTFSB_PART}";
                        compressed = ${SWUPDATE_ROOT_FILE_COMPRESSED};
                   }
             );
             bootenv: (
                    {
                        name = "default";
                        value = "1";
                    }
            );
        }
    }

}
EOF

FILES="${SWUPDATE_STAGING_DIR}/sw-description ${SWUPDATE_IMAGES_DIR}/${SWUPDATE_ROOT_FILENAME}"
rm -f ${SWUPDATE_IMAGES_DIR}/${SWUPDATE_PRODUCT_NAME}_${SWUPDATE_VERSION}.swu
for i in ${FILES}; do
    dirname=`dirname $i`;
    filename=`basename $i`;
    pushd $dirname;
    if [ -f ${SWUPDATE_IMAGES_DIR}/${SWUPDATE_PRODUCT_NAME}_${SWUPDATE_VERSION}.swu ]; then
        append="-A"
    else
        append=
    fi
    echo $filename | cpio -ov $append -H crc -F ${SWUPDATE_IMAGES_DIR}/${SWUPDATE_PRODUCT_NAME}_${SWUPDATE_VERSION}.swu;
    popd;
done
mkdir -p `dirname ${GRUB_ENV_PATH}`
${GRUB_EDITENV_BIN} ${GRUB_ENV_PATH} create
