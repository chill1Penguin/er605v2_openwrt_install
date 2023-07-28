

# TP-Link ER605 v2 OpenWrt Installer
This repository contains the scripts needed to install OpenWrt on a factory-flashed TP-Link ER605 hardware version 2 router.

**:warning::warning: Use at your own risk. Your device may become bricked if you do something wrong or as a result of a bug. :warning::warning:**

**:warning::warning: These scripts have not been extensively tested and are still considered experimental! Feedback is welcome! :warning::warning:**

## Initramfs Image
Currently built using a minimized OpenWrt 23.05.0-rc2 initramfs image. You can use any OpenWrt initramfs image that supports the ER605 and is 5,242,880 (0x00500000) bytes or smaller in size.

## Steps to Install

**:warning: After the install, you will NOT be able to use the recovery mode of the ER605 to flash a factory image to recover from a bad install. You will need to use ubiformat to reflash your mtd3 (firmware) partition if you ever want to restore to the default firmware. :warning:**

 1. Backup your MTD partitions (recommended). Example: [https://openwrt.org/docs/guide-user/installation/generic.backup?do=#create_full_mtd_backup](https://openwrt.org/docs/guide-user/installation/generic.backup?do=#create_full_mtd_backup)
 2. Enable SSH on your ER605 by logging into the web configuration GUI, navigating to System Tools > Diagnostics > Remote Assistance, and enabling Remote Assistance.
 3. Generate the root password using the Python script.
```
python3 er605rootpw.py
```
 5. SSH into the ER605 and login using the `root` username. On newer firmwares, you may need to run `enable` and then `debug` after logging in to get to the SSH shell.
 6. Download openwrt-initramfs-compact.bin and er605v2_write_initramfs.sh to the ER605 (run these commands in the SSH shell).
 ```
 cd /tmp
 wget http://<URL to openwrt-initramfs-compact.bin>
 wget http://<URL to er605v2_write_initramfs.sh>
 chmod +x er605v2_write_initramfs.sh
```
 6. Run er605v2_write_initramfs.sh script to flash the initramfs image.
 ```
 ./er605v2_write_initramfs.sh openwrt-initramfs-compact.bin
```
 7. Reboot the ER605 and wait for it to reboot.
 8. Change your computer's IP address to the `192.168.1.x` subnet.
 9. SSH into the device using the default OpenWrt IP address (`ssh root@192.168.1.1`).
 10. Upload the two shell scripts to the device. For example:
  
 *On the computer:*
 ```
 cd <the folder containing the shell scripts and the sysupgrade image>
 python3 -m http.server 8000 -b <your computer's IP address>
```
 *On the router over SSH:* 
```
cd /tmp
wget http://<your computer's IP address>:8000/er605v2_update_ubi_layout.sh
wget http://<your computer's IP address>:8000/er605v2_write_sysupgrade.sh
chmod +x er605v2_update_ubi_layout.sh er605v2_write_sysupgrade.sh 
``` 
 11. Update the ER605 UBI layout:
```
./er605v2_update_ubi_layout.sh 
```
 12. Write the sysupgrade image:
```
./er605v2_write_sysupgrade.sh http://<your computer's IP address>:8000/<your openwrt-sysupgrade.bin>
```
 13. Reboot the ER605.
 14. Your router should now boot into OpenWrt! :smile:

