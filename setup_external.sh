if [ -z ${EXTERNAL_DIR} ]; then
    echo "EXTERNAL_DIR is not specified, using base_external"
    EXTERNAL_DIR=base_external
fi
EXTERNAL_DIR_BR_RELATIVE=../${EXTERNAL_DIR}
EXTERNAL_DIR_BR_RELATIVE_LIST=${EXTERNAL_DIR_BR_RELATIVE}
if [ -e ${EXTERNAL_DIR}/additional_external_depends.sh ]; then
    source ${EXTERNAL_DIR}/additional_external_depends.sh
    EXTERNAL_DIR_BR_RELATIVE_LIST=${EXTERNAL_DIR_BR_RELATIVE_LIST}:${ADDITIONAL_DIR_BR_RELATIVE}
fi
