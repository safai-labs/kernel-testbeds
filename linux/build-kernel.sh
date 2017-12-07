#!/bin/bash

OVERLAY_PATH=../linux-aifs-dev-rootfs/overlay/

set -e
pushd ../../linux-aifs-build-new

make fs/aifs/aifs.ko && \
	make modules_install INSTALL_MOD_PATH=$OVERLAY_PATH || exit $?

popd
pushd ../../linux-aifs-dev-rootfs/buildroot
make V=1
popd
