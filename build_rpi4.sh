#!/bin/bash

OUTPUT="$(pwd)/images"
BUILD_VERSION="21.02.3"
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
           PACKAGES="bash kmod-rt2800-usb rt2800-usb-firmware kmod-cfg80211 kmod-lib80211 kmod-mac80211 kmod-rtl8192cu \
                     base-files block-mount fdisk luci-app-minidlna minidlna samba4-server bcm27xx-gpu-fw \
                     samba4-libs luci-app-samba4 wireguard-tools luci-app-wireguard busybox ca-bundle ppp ppp-mod-pppoe \
                     openvpn-openssl luci-app-openvpn watchcat openssh-sftp-client kmod-usb-storage-extras opkg \
                     luci-base luci-ssl luci-mod-admin-full luci-theme-bootstrap bcm27xx-eeprom logd partx-utils \
                     kmod-usb-storage kmod-usb-ohci kmod-usb-uhci e2fsprogs fdisk resize2fs libustream-wolfssl \
                     htop debootstrap luci-compat luci-lib-ipkg dnsmasq luci-app-ttyd cypress-firmware-43455-sdio \
                     irqbalance ethtool netperf speedtest-netperf iperf3 cfdisk cypress-nvram-43455-sdio-rpi-4b urandom-seed \
                     curl wget rsync file htop lsof less mc tree usbutils bash diffutils kmod-usb-hid odhcpd-ipv6only \
                     openssh-sftp-server nano luci-app-ttyd kmod-fs-exfat ntfs-3g kmod-nft-offload odhcp6c uci wpad-basic-wolfssl \
                     kmod-usb-storage-uas block-mount luci-app-minidlna kmod-fs-ext4 kmod-nls-cp437 nftables uclient-fetch \
                     urngd usign vpn-policy-routing wg-installer-client wireguard-tools kmod-nls-iso8859-1 netifd \
                     kmod-usb-core kmod-usb3 dropbear e2fsprogs fstools iwinfo kmod-brcmfmac libc libgcc mkf2fs \
                     zlib firewall4 wireless-regdb f2fsck openssh-sftp-server wget-ssl kmod-sound-arm-bcm2835 \
                     kmod-usb-wdm kmod-usb-net-ipheth usbmuxd kmod-usb-net-asix-ax88179  kmod-sound-core mtd \
                     kmod-usb-net-cdc-ether mount-utils kmod-rtl8xxxu kmod-rtl8187 lsblk kmod-usb-net-lan78xx procd-ujail \
                     kmod-rtl8xxxu rtl8188eu-firmware kmod-rtl8192ce kmod-rtl8192cu kmod-rtl8192de luci-compat procd-seccomp  \
                     adblock luci-app-adblock kmod-fs-squashfs squashfs-tools-unsquashfs squashfs-tools-mksquashfs procd \
                     kmod-fs-f2fs kmod-fs-vfat git git-http jq kmod-ath9k-htc luci-ssl kmod-usb-net-rtl8152 luci-lib-ipkg" \
            FILES="${BASEDIR}/files/" \
            BIN_DIR="${OUTPUT}"
