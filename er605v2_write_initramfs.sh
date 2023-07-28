#!/bin/sh

vol_count=$(cat /sys/class/ubi/ubi0/volumes_count)
vol_kernel=
vol_kernelb=

if [ $# -ne 1 ] ; then
    echo "USAGE: <path to openwrt-initramfs.bin> EXAMPLE: ./er605v2_write_initramfs.sh openwrt-initramfs.bin"
    exit 1
fi

i=0
name=
while [ $i -lt $vol_count ]; do
    name=$(cat /sys/class/ubi/ubi0_$i/name)
    case $name in
      "kernel")
         vol_kernel=$i
         ;;
      "kernel.b")
         vol_kernelb=$i
         ;;
    esac
    i=`expr $i + 1`
done

if [ -z $vol_kernel ] || [ -z $vol_kernelb ] ; then
   echo "ERROR: A required UBI volume was not found."
   exit 1
fi

echo "Found kernel ubi partitions (ubi0_$vol_kernel and ubi0_$vol_kernelb). Flashing the initramfs.bin..."

ubiupdatevol /dev/ubi0_$vol_kernel $1
ubiupdatevol /dev/ubi0_$vol_kernelb $1

sync

echo "Done!"

