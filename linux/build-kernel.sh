#!/bin/bash

set -e
pushd ../../linux-aifs-build-new

make fs/aifs/aifs.ko && \
make modules_install INSTALL_MOD_PATH=../linux-aifs-dev-rootfs/overlay/

popd

pushd ../../linux-aifs-dev-rootfs/buildroot
make 
popd
