#!/bin/bash
DATA_PART_FAKEROOT_SCRIPT=${BUILD_DIR}/data-partition/fakeroot.fs
DATA_PART_SOURCE=${BASE_DIR}/data-partition
DATA_PART_IMAGE_FILE=${BASE_DIR}/images/data.ext2
MKFS_UTIL=${HOST_DIR}/sbin/mkfs.ext2
DATA_PART_LABEL="project-data"
mkdir -p `dirname ${DATA_PART_FAKEROOT_SCRIPT}`

cat << EOF > ${DATA_PART_FAKEROOT_SCRIPT}
#!/bin/sh
set -e
chown -h -R 0:0 ${DATA_PART_SOURCE}
rm -f ${DATA_PART_IMAGE_FILE}
${MKFS_UTIL} -d ${DATA_PART_SOURCE} -r 1 -N 0 -m 5 -L ${DATA_PART_LABEL} -O ^64bit ${DATA_PART_IMAGE_FILE} "120M"
EOF
chmod a+x ${DATA_PART_FAKEROOT_SCRIPT}
PATH=${HOST_DIR}/bin:${HOST_DIR}/usr/bin:${HOST_DIR}/usr/sbin:${PATH} ${HOST_DIR}/bin/fakeroot -- ${DATA_PART_FAKEROOT_SCRIPT}
