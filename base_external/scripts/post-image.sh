#!/bin/bash
../base_external/scripts/build-swupdate-swu.sh
../base_external/scripts/build-data-partition-image.sh
support/scripts/genimage.sh -c ../base_external/configs/genimage.cfg
