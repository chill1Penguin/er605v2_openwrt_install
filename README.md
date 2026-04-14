
# TP-Link Omada ER605 v2.XX / Festa FR205 v1.XX OpenWrt Installer
This repository provides a method to install OpenWrt on a factory-flashed TP-Link Omada ER605 v2.XX or Festa FR205 v1.XX router. The TP-Link Festa FR205 is essentially a re-labeled ER605 v2.

> [!CAUTION] 
> **Use at your own risk.** Your device may become bricked if you do something wrong or as a result of a bug.

## Initramfs Image
The initramfs image is based on OpenWrt version 23.05.0. If you would like to build your own initramfs image, see the files in the image-build-files directory. The initramfs image needs to be 5,242,880 (0x00500000) bytes or smaller in size to fit into the factory kernel UBI volume.

## Steps to Install

> [!WARNING] 
> **After the install, you will not be able to use the recovery mode of the ER605 or FR205 to flash a factory image to recover from a bad install.** You will need to use ubiformat to reflash your mtd3 (firmware) partition if you ever want to restore to the default firmware.

> [!IMPORTANT] 
> **You will need to use ER605 firmware v2.2.5 or below, or FR205 firmware v1.0.1 or below.** For newer firmwares, please see downgrading steps in [#30](https://github.com/chill1Penguin/er605v2_openwrt_install/issues/30) first.
>
> **Do not connect the router to the internet during this process.** If you do, you will need an unknown signed token that is generated online to access the router through SSH. To avoid this, do not connect the router to the internet after performing a factory reset, and execute this procedure conecting it only to your computer through Port 5.

 1. Disconnect **everything** from your router, except the power cord. Plug only your computer directly into **Port 5** via ethernet.

 2. Perform a factory reset on your router by holding down the physical 'Reset' button for at least 10 seconds. The SYS light will start solid, and once it starts to blink at a faster pace, release the button.
 
 3. In your browser, visit `192.168.0.1` and complete the setup process to access the web configuration GUI.
 
 4. Enable SSH on your ER605 by navigating to System Tools > Diagnostics > Remote Assistance, and enabling Remote Assistance.
 
 5. Generate your shell password by clicking [here](https://chill1penguin.github.io/er605v2_openwrt_install/er605rootpw.html).
 
 6. SSH into your router. You may have trouble estalishing an ssh connection to the router. Take a look into these [ssh tips](SSH_TIPS.md). Follow the steps below for the firmware version you have installed:
    - **ER605 v2.0.1 and below:** Login using the username `root` and the "root password" generated in the previous step.<br>
    - **ER605 v2.1.1 - v2.2.5, and FR205 v1.0.1:** Login using your web configuration GUI credentials. Then run the `enable` command followed by the `debug` command. When you are prompted for a password, enter the "CLI debug mode password" generated in the previous step.

    _(If you are still unable to proceed, you may still need to downgrade your ER605 firmware to v2.2.5 or below, or FR205 firmware to v1.0.1 or below. For newer firmwares, please see downgrading steps in [#30](https://github.com/chill1Penguin/er605v2_openwrt_install/issues/30) first, and attempt this process again.)_
 
 7. Backup your MTD partitions (recommended). You can follow a way to achieve this [here](MTD_backup/README.md).
 
 8. Download the image files to your computer and transfer `openwrt-initramfs-compact.bin` and `er605v2_write_initramfs.sh` to the ER605 or FR205.

     To do this offline, run a simple web server on your computer to serve the files running the following:

     ```shell
     curl -o er605v2_write_initramfs.sh https://raw.githubusercontent.com/chill1Penguin/er605v2_openwrt_install/main/er605v2_write_initramfs.sh
     curl -o openwrt-initramfs-compact.bin https://raw.githubusercontent.com/chill1Penguin/er605v2_openwrt_install/main/openwrt-initramfs-compact.bin

     for i in er605v2_write_initramfs.sh openwrt-initramfs-compact.bin; do
         { echo -ne "HTTP/1.0 200 OK\r\nContent-Length: $(wc -c < $i )\r\n\r\n"; cat $i; } | nc -l -p 8080 ;
     done
     ```
      And then run these commands in the SSH shell of the ER605: (Replace the IP with your computer's IP connected to the LAN port):
      ```shell
      cd /tmp
      curl -o er605v2_write_initramfs.sh http://192.168.0.100:8080/er605v2_write_initramfs.sh
      curl -o openwrt-initramfs-compact.bin http://192.168.0.100:8080/openwrt-initramfs-compact.bin
      chmod +x er605v2_write_initramfs.sh
      ```

 9. Verify the checksum of the openwrt-initramfs-compact.bin image. It should match the checksum found in the [md5sums](md5sums) file. You can get the checksum by running:
      ```shell
      md5sum openwrt-initramfs-compact.bin
      ```
 10. Run er605v2_write_initramfs.sh script to flash the initramfs image.
      ```shell
      ./er605v2_write_initramfs.sh openwrt-initramfs-compact.bin
      ```
 11. Reboot the ER605 or FR205 and wait for it to reboot.
 
 12. Open a web browser and navigate to [http://192.168.1.1/](http://192.168.1.1/). If the page does not load, try waiting a bit longer or clearing your browser cache. (_Having another router or DHCP server connected to the ER605 or FR205 could cause page load issues due to an IP address conflict. If you cannot access the web page, disconnect all unnecessary devices from the ER605 and try again._)
 
 13. Follow the steps on the web page. You can find a sysupgrade image at [https://downloads.openwrt.org](https://downloads.openwrt.org). If the install fails, click [here](https://downloads.openwrt.org/releases/23.05.0/targets/ramips/mt7621/openwrt-23.05.0-ramips-mt7621-tplink_er605-v2-squashfs-sysupgrade.bin) to download the v23.05.0 sysupgrade image first, then upgrade to the latest version of OpenWrt afterwards.
 
 14. After rebooting, your ER605 or FR205 should boot into OpenWrt! :smile:

## Additional Information
Users have reported that the shell password generator may also work for the following devices:
- TP-Link Omada ER7206 v2.26 ([#22](https://github.com/chill1Penguin/er605v2_openwrt_install/issues/22))
- TP-Link Omada ER7212PC v1.6 ([#22](https://github.com/chill1Penguin/er605v2_openwrt_install/issues/22))
