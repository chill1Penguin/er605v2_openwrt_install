
# TP-Link ER605 v2 OpenWrt Installer
This repository contains the scripts needed to install OpenWrt on a factory-flashed TP-Link ER605 hardware version 2 router.

**:warning::warning: Use at your own risk. Your device may become bricked if you do something wrong or as a result of a bug. :warning::warning:**

## Initramfs Image
The initramfs image is currently using OpenWrt version 23.05.0-rc2. If you would like to build your own initramfs image, see the files in the image-build-files directory. The initramfs image needs to be 5,242,880 (0x00500000) bytes or smaller in size to fit into the factory kernel UBI volume.

## Steps to Install

**:warning: After the install, you will NOT be able to use the recovery mode of the ER605 to flash a factory image to recover from a bad install. You will need to use ubiformat to reflash your mtd3 (firmware) partition if you ever want to restore to the default firmware. :warning:**

 1. Backup your MTD partitions (recommended). Example: [https://openwrt.org/docs/guide-user/installation/generic.backup?do=#create_full_mtd_backup](https://openwrt.org/docs/guide-user/installation/generic.backup?do=#create_full_mtd_backup)
 2. Enable SSH on your ER605 by logging into the web configuration GUI, navigating to System Tools > Diagnostics > Remote Assistance, and enabling Remote Assistance.
 3. Generate the root password by clicking [here](https://raw.githubusercontent.com/chill1Penguin/er605v2_openwrt_install/main/er605rootpw.html).

 4. SSH into the ER605 and login using the `root` username. On newer firmwares, you may need to run `enable` and then `debug` after logging in to get to the SSH shell.
 5. Download openwrt-initramfs-compact.bin and er605v2_write_initramfs.sh to the ER605 (run these commands in the SSH shell).
 ```
 cd /tmp
 wget https://raw.githubusercontent.com/chill1Penguin/er605v2_openwrt_install/main/er605v2_write_initramfs.sh
 wget https://raw.githubusercontent.com/chill1Penguin/er605v2_openwrt_install/main/openwrt-initramfs-compact.bin
 chmod +x er605v2_write_initramfs.sh
```
 6. Run er605v2_write_initramfs.sh script to flash the initramfs image.
```
 ./er605v2_write_initramfs.sh openwrt-initramfs-compact.bin
```
 7. Reboot the ER605 and wait for it to reboot.
 8. Open a web browser and navigate to [http://192.168.1.1/](http://192.168.1.1/)
 9. Follow the steps on the web page. You can find a sysupgrade image at [https://downloads.openwrt.org](https://downloads.openwrt.org). Click [here](https://downloads.openwrt.org/releases/23.05.0-rc2/targets/ramips/mt7621/openwrt-23.05.0-rc2-ramips-mt7621-tplink_er605-v2-squashfs-sysupgrade.bin) to download the v23.05.0-rc2 sysupgrade image.
 10. After rebooting, your ER605 should boot into OpenWrt! :smile:
