#!/bin/sh

kernel_name=$(cat /sys/class/ubi/ubi0_5/name)
rootfs_name=$(cat /sys/class/ubi/ubi0_6/name)

if [ $kernel_name != "kernel" ] || [ $rootfs_name != "rootfs" ] ; then
    echo "The UBI layout is wrong. Have you run er605v2_update_ubi_layout.sh yet?"
    exit 1
fi

if [ $# -ne 1 ] ; then
    echo "USAGE: <wget path to sysupgrade.bin> EXAMPLE: ./er605v2_write_sysupgrade.sh \"http://192.168.0.55:8000/openwrt-sysupgrade.bin\""
    exit 1
fi

wget -O - $1 | tar -xf - -C /tmp

ubiupdatevol /dev/ubi0_5 /tmp/sysupgrade-tplink_er605-v2/kernel
ubiupdatevol /dev/ubi0_6 /tmp/sysupgrade-tplink_er605-v2/root

rm -R /tmp/sysupgrade-tplink_er605-v2

echo "Done!"

