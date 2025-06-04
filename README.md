
# TP-Link ER605 v2 OpenWrt Installer
This repository provides a method to install OpenWrt on a factory-flashed TP-Link ER605 hardware version 2 or 2.2 router.

> [!CAUTION] 
> **Use at your own risk. Your device may become bricked if you do something wrong or as a result of a bug.**

## Initramfs Image
The initramfs image is based on OpenWrt version 23.05.0. If you would like to build your own initramfs image, see the files in the image-build-files directory. The initramfs image needs to be 5,242,880 (0x00500000) bytes or smaller in size to fit into the factory kernel UBI volume.

## Steps to Install

> [!WARNING] 
> **After the install, you will NOT be able to use the recovery mode of the ER605 to flash a factory image to recover from a bad install. You will need to use ubiformat to reflash your mtd3 (firmware) partition if you ever want to restore to the default firmware.**

> [!IMPORTANT] 
> **DO NOT connect the router to the internet.** If you do you will need an uknown signed token that is generated online to access the router through SSH. To avoid this do not connect the router to the internet and execute this procedure conecting it only to your PC through LAN port.

 1. Enable SSH on your ER605 by logging into the web configuration GUI, navigating to System Tools > Diagnostics > Remote Assistance, and enabling Remote Assistance.
 2. Generate your shell password by clicking [here](https://chill1penguin.github.io/er605v2_openwrt_install/er605rootpw.html).
 3. SSH into your ER605. You may have trouble estalishing an ssh connection to the router. Take a look into these [ssh tips](SSH_TIPS.md). Follow the steps below for the firmware version you have installed:<br>
***v2.0.1 and below:*** Login using the username `root` and the "root password" generated in the previous step.<br>
***v2.1.1 and above:*** Login using your web configuration GUI credentials. Then run the `enable` command followed by the `debug` command. When you are prompted for a password, enter the "CLI debug mode password" generated in the previous step.
 4. Backup your MTD partitions (recommended). You can follow a way to achieve this [here](MTD_backup/README.md).
 5. Transfer the image files `openwrt-initramfs-compact.bin`and `er605v2_write_initramfs.sh` to the ER605. To do this offline run a simple web server on your PC to serve the files running the following:
```shell
for i in er605v2_write_initramfs.sh openwrt-initramfs-compact.bin; do
    { echo -ne "HTTP/1.0 200 OK\r\nContent-Length: $(wc -c < $i )\r\n\r\n"; cat $i; } | nc -l -p 8080 ;
done
```
And then run these commands in the SSH shell of the ER605: (Replace the IP with your PC's IP connected to the LAN port) 
 ```shell
 cd /tmp
 curl -o er605v2_write_initramfs.sh http://192.168.0.100:8080/er605v2_write_initramfs.sh
 curl -o openwrt-initramfs-compact.bin http://192.168.0.100:8080 openwrt-initramfs-compact.bin
 chmod +x er605v2_write_initramfs.sh
 ```

 6. Verify the checksum of the openwrt-initramfs-compact.bin image. It should match the checksum found in the [md5sums](md5sums) file. You can get the checksum by running:
 ```shell
 md5sum openwrt-initramfs-compact.bin
 ```
 7. Run er605v2_write_initramfs.sh script to flash the initramfs image.
 ```shell
 ./er605v2_write_initramfs.sh openwrt-initramfs-compact.bin
 ```
 8. Reboot the ER605 and wait for it to reboot.
 9. Open a web browser and navigate to [http://192.168.1.1/](http://192.168.1.1/). If the page does not load, try waiting a bit longer or clearing your browser cache. (_Having another router or DHCP server connected to the ER605 could cause page load issues due to an IP address conflict. If you cannot access the web page, disconnect all unnecessary devices from the ER605 and try again._)
 10. Follow the steps on the web page. You can find a sysupgrade image at [https://downloads.openwrt.org](https://downloads.openwrt.org). Click [here](https://downloads.openwrt.org/releases/23.05.0/targets/ramips/mt7621/openwrt-23.05.0-ramips-mt7621-tplink_er605-v2-squashfs-sysupgrade.bin) to download the v23.05.0 sysupgrade image.
 11. After rebooting, your ER605 should boot into OpenWrt! :smile:
