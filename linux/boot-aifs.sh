#!/bin/bash

# Make sure you have HPET (High-precision Event Timer) as the clock source
# 
CLOCK_SOURCE=$(cat /sys/devices/system/clocksource/clocksource0/current_clocksource)
CLOCK_SOURCES=$(cat /sys/devices/system/clocksource/clocksource0/available_clocksource)

if [ x$CLOCK_SOURCE = xtcs -o x$CLOCK_SOURCE = xtcs_early ] ; then
	echo "Fix the clock source by: " 1>&2
	echo "    echo hpet | sudo tee /sys/devices/system/clocksource/clocksource0/current_clocksource" 1>&2
	exit 1
fi

MAKE=make
QEMU=qemu-system
QEMU_ARCH=x86_64
IMGDIR=../../linux-aifs-dev-rootfs/buildroot/output/images
KERNEL=${IMGDIR}/bzImage

# KERNEL=/boot/vmlinuz-4.8.0-9pfs

ENABLE_KVM="-enable-kvm -machine pc-q35-2.10 -cpu host -smp cores=4"
# ENABLE_SERIAL="--nographic -serial mon:stdio"
ENABLE_SERIAL="--curses"
ROOTFS=/home/masud/projects/labs/AiFS/linux-aifs-dev-rootfs/buildroot/output/images/rootfs.ext4
# ROOTFS=~/projects/labs/AiFS/linux-aifs-dev-rootfs/buildroot/images/rootfs.ext2
# KERNEL_APPEND="console=ttyS"
# KERNEL_APPEND="${KERNEL_APPEND} clocksource=kvm-clock console=ttyS"
ROOTFS=${IMGDIR}/rootfs.ext2

DRIVES=$(echo /dev/data/aifs-ovl-{lower,upper})

build_rootfs() {
	${MAKE} rootfs
}

boot_kernel() {
	${QEMU}-${QEMU_ARCH} \
		-s \
		${ENABLE_KVM} ${ENABLE_SERIAL}	\
		-drive file=${ROOTFS},format=raw,index=0 \
		$(for k in $DRIVES; do echo -n "-drive format=raw,file=$k "; done ) \
		-kernel ${KERNEL} 		 \
		-append "root=/dev/sda ${KERNEL_APPEND}"  \
		"$@"
}

boot_kernel "$@"
