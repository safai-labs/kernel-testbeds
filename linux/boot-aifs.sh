#!/bin/bash


MAKE=make
QEMU=qemu-system
QEMU_ARCH=x86_64
KERNEL=~/projects/labs/AiFS/linux-aifs-build-new/arch/x86_64/boot/bzImage
KERNEL_APPEND="console=ttyS"
ENABLE_KVM="--enable-kvm"
ENABLE_SERIAL="--nographic"
ROOTFS=~/projects/labs/AiFS/linux-aifs-dev-rootfs/buildroot/images/rootfs.ext2

DRIVES=$(echo /dev/data/aifs-ovl-{lower,upper})

build_rootfs() {
	${MAKE} rootfs
}

boot_kernel() {
	${QEMU}-${QEMU_ARCH} 			 \
		-gdb tcp::1234 \
		-S \
		-drive file=${ROOTFS},format=raw,index=0 \
		$(for k in $DRIVES; do echo -n "-drive format=raw,file=$k "; done ) \
		-kernel ${KERNEL} 		 \
		-append "nokaslr root=/dev/sda ${KERNEL_APPEND}"  \
		${ENABLE_KVM} ${ENABLE_SERIAL} "$@"
}

boot_kernel "$@"
