#!/bin/sh

vol_count=$(cat /sys/class/ubi/ubi0/volumes_count)
vol_bootloader=
vol_tddp=
vol_firmware_info=
vol_device_info=
vol_kernel=

i=0
name=
while [ $i -lt $vol_count ]; do
    name=$(cat /sys/class/ubi/ubi0_$i/name)
    case $name in
      "bootloader.b")
         vol_bootloader=$i
         ;;
      "tddp.b")
         vol_tddp=$i
         ;;
      "firmware-info.b")
         vol_firmware_info=$i
         ;;
      "device-info.b")
         vol_device_info=$i
         ;;
      "kernel.b")
         vol_kernel=$i
         ;;
    esac
    i=`expr $i + 1`
done

if [ -z $vol_bootloader ] || [ -z $vol_tddp ] || [ -z $vol_firmware_info ] || [ -z $vol_device_info ] || [ -z $vol_kernel ] ; then
   echo "ERROR: A required UBI volume was not found."
fi

dd if=/dev/ubi0_$vol_bootloader of=/tmp/bootloader.img
dd if=/dev/ubi0_$vol_tddp of=/tmp/tddp.img
dd if=/dev/ubi0_$vol_firmware_info of=/tmp/firmware-info.img
dd if=/dev/ubi0_$vol_device_info of=/tmp/device-info.img
dd if=/dev/ubi0_$vol_kernel of=/tmp/kernel.img
printf "\xAA\x55\xD9\x8F\x04\xE9\x55\xAA\x00\x00\x00\x40\x00\x00\x00\x00{\"dbootFlag\": \"1\",\"integerFlag\": \"1\",\"fwFlag\": \"GOOD\",\"score\":1}" > /tmp/extra-para.img

mtd_num=$(cat /sys/class/ubi/ubi0/mtd_num)
ubidetach -m $mtd_num
ubiformat /dev/mtd$mtd_num -y -O 2048
ubiattach -m $mtd_num -O 2048

ubimkvol /dev/ubi0 -n 0 -N bootloader -s 524288 -t static
ubimkvol /dev/ubi0 -n 1 -N firmware-info -S 2 -t static
ubimkvol /dev/ubi0 -n 2 -N device-info -S 2 -t static
ubimkvol /dev/ubi0 -n 3 -N tddp -S 2 -t static
ubimkvol /dev/ubi0 -n 4 -N extra-para -S 1 -t static
ubimkvol /dev/ubi0 -n 5 -N kernel -S 42 -t dynamic
ubimkvol /dev/ubi0 -n 6 -N rootfs -S 100 -t dynamic
ubimkvol /dev/ubi0 -n 7 -N rootfs_data -m -t dynamic

ubiupdatevol /dev/ubi0_0 /tmp/bootloader.img
ubiupdatevol /dev/ubi0_1 /tmp/firmware-info.img
ubiupdatevol /dev/ubi0_2 /tmp/device-info.img
ubiupdatevol /dev/ubi0_3 /tmp/tddp.img
ubiupdatevol /dev/ubi0_4 /tmp/extra-para.img
ubiupdatevol /dev/ubi0_5 /tmp/kernel.img

sync

rm /tmp/bootloader.img /tmp/firmware-info.img /tmp/device-info.img /tmp/tddp.img /tmp/extra-para.img /tmp/kernel.img

echo "Done!"

