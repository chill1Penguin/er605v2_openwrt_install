# TP-Link ER605 v2 OpenWrt Installer
This repository contains the tools and scripts needed to install OpenWrt on a factory-flashed TP-Link ER605 hardware version 2 router.

**:warning::warning: Use at your own risk. Your device may become bricked if you do something wrong or as a result of a bug. :warning::warning:**

**:warning::warning: This code has not been extensively tested and is still considered experimental! :warning::warning:**

## Requirements
A Linux system with a QEMU user-space MIPS emulator (`qemu-user` package on Ubuntu) and Make.
Tested on Ubuntu 22.04 LTS.

## Initramfs Image
Currently built using a minimized OpenWrt 23.05.0-rc2 initramfs image. You can use any OpenWrt initramfs image that supports the ER605 and is 5,242,880 (0x00500000) bytes or smaller in size.

## Steps to Install

 1. Open a terminal and run the following commands
```
git clone https://github.com/chill1Penguin/er605v2_openwrt_install
cd er605v2_openwrt_install
make download
make
```
 2. Connect a computer to the router with an ethernet cable and set your computer's IP address to an address in the `192.168.0.x` subnet.
 3. Boot the ER605 into recovery mode by holding down the reset button while powering on the device. You will need to hold the reset button in for 20 seconds or longer while the device boots.
 4. Navigate your web browser to [http://192.168.0.10](http://192.168.0.10)
 5. Upload the built recovery flash image to the device (`er605v2_openwrt_recovery.bin`).
 6. Wait for the device to reboot.
 7. Change your computer's IP address to the `192.168.1.x` subnet.
 8. SSH into the device using the default OpenWrt IP address (`ssh root@192.168.1.1`).
 9. Upload the `er605v2_write_sysupgrade.sh` shell script to the device and execute it. For example:
  
 *On the computer:*
 ```
 cd <the folder containing the er605v2_write_sysupgrade.sh script and the sysupgrade image>
 python3 -m http.server 8000 -b <your computer's IP address>
```
 *On the router over SSH:* 
```
cd /tmp
wget http://<your computer's IP address>:8000/er605v2_write_sysupgrade.sh
chmod +x er605v2_write_sysupgrade.sh
wget http://<your computer's IP address>:8000/<your openwrt-sysupgrade.bin>
./er605v2_write_sysupgrade.sh <your openwrt-sysupgrade.bin>
``` 
10. Reboot the router.
11. Your router should now boot into OpenWrt! :smile:

