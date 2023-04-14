#!/bin/bash

OUTPUT="$(pwd)/images"
BUILD_VERSION="22.03.3"
BUILDER="https://downloads.openwrt.org/releases/${BUILD_VERSION}/targets/bcm27xx/bcm2711/openwrt-imagebuilder-${BUILD_VERSION}-bcm27xx-bcm2711.Linux-x86_64.tar.xz"
KERNEL_PARTSIZE=256 #Kernel-Partitionsize in MB
ROOTFS_PARTSIZE=8192 #Rootfs-Partitionsize in MB
BASEDIR=$(realpath "$0" | xargs dirname)

# download image builder
if [ ! -f "${BUILDER##*/}" ]; then
	wget "$BUILDER"
	tar xJvf "${BUILDER##*/}"
fi

[ -d "${OUTPUT}" ] || mkdir "${OUTPUT}"

cd openwrt-*/

# clean previous images
make clean

# Packages are added if no prefix is given, '-packaganame' does not integrate a package
sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=$KERNEL_PARTSIZE/g" .config
sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE/g" .config

make image  PROFILE="rpi-4" \
           PACKAGES="kmod-usb-storage luci-compat luci-lib-ipkg cfdisk resize2fs kmod-usb-storage-extras \
                     kmod-usb-storage-uas usbutils block-mount ntfs-3g kmod-fs-ext4 wget-ssl lsblk \
                     luci-compat luci-lib-ipkg kmod-usb-net-rtl8152 luci luci-ssl kmod-ath9k-htc nano" \
            FILES="${BASEDIR}/files/" \
            BIN_DIR="${OUTPUT}"
