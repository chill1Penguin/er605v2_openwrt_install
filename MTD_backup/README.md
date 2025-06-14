# MTD partitions backup
This steps provide a method of backing up TP-Link ER605 MTD partitions before installing OpenWRT in case you want to fall back to the original firmware. These instructions and code are based on this How-To [https://openwrt.org/docs/guide-user/installation/generic.backup?do=#create_full_mtd_backup](https://openwrt.org/docs/guide-user/installation/generic.backup?do=#create_full_mtd_backup) and [these](https://github.com/chill1Penguin/er605v2_openwrt_install/issues/21#issue-2843453155)  intructions.

> [!WARNING] 
> **Use at your own risk. Your device may become bricked if you do something wrong or as a result of a bug.** It is assumed that you understand what these scripts do and what you are doing.

1. We asume you have followed the steps before and are logged in as root in the router. Edit the IP address to match yours and run the following code in the router.
```shell
cat << "EOF" > /tmp/backup.sh
#!/bin/sh

BACKUP_HOST="192.168.0.100"  # Your laptop's IP address
BACKUP_PORT="9999"            # Port to use for transfer
echo "Backup host ${BACKUP_HOST}"

echo -n > /tmp/md5sum

cat /proc/mtd | tail -n+2 | while read; do
  MTD_DEV=$(echo ${REPLY} | cut -f1 -d:)
  MTD_NAME=$(echo ${REPLY} | cut -f2 -d\")
  FILENAME="${MTD_DEV}_${MTD_NAME}.backup"
  
  echo "Backing up ${MTD_DEV} (${MTD_NAME})"
  # First send filename
  echo "$FILENAME" | busybox nc ${BACKUP_HOST} ${BACKUP_PORT}
  # Small delay to ensure the receiver is ready
  sleep 1
  # Then send the data
  dd if=/dev/${MTD_DEV}ro | busybox nc ${BACKUP_HOST} ${BACKUP_PORT}
  SUM=$(dd if=/dev/${MTD_DEV}ro | md5sum | cut -f1 -d" ")
  echo -e "$SUM\t$FILENAME" >> /tmp/md5sums
  # Small delay between files
  sleep 1
done

echo md5sums | busybox nc ${BACKUP_HOST} ${BACKUP_PORT}
dd if=/tmp/md5sums | busybox nc ${BACKUP_HOST} ${BACKUP_PORT}

EOF

chmod +x /tmp/backup.sh
```
2. Download and run the [`receive.sh`](receive.sh) shell script in your PC.
3. Run `/tmp/backup.sh` shell script in the router.

router output sample:
```
root@ER605:/# /tmp/backup.sh
Backup host 192.168.0.100
Backing up mtd0 (Bootloader)
1024+0 records in
1024+0 records out
1024+0 records in
1024+0 records out
Backing up mtd1 (Config)
1024+0 records in
1024+0 records out
1024+0 records in
1024+0 records out
Backing up mtd2 (Factory)
512+0 records in
512+0 records out
...
...
Backing up mtd25 (log_recovery)
2232+0 records in
2232+0 records out
2232+0 records in
2232+0 records out
Backing up mtd26 (database)
61504+0 records in
61504+0 records out
61504+0 records in
61504+0 records out
2+1 records in
2+1 records out
root@ER605:/# 
```

PC output sample
```
$ ./receive.sh 
Receiving mtd0_Bootloader.backup...
Receiving mtd1_Config.backup...
Receiving mtd2_Factory.backup...
...
...
Receiving mtd21_firmware-info.b.backup...
Receiving mtd22_extra-para.b.backup...
Receiving mtd23_log.b.backup...
Receiving mtd24_rootfs_data.b.backup...
Receiving mtd25_log_recovery.backup...
Receiving mtd26_database.backup...
Receiving md5sums...
^C
$ 
```

Backup takes around 5 minutes. Don't be impatient.

4. Once transfer is complete interrupt the receive script in your PC and run `md5sum -c md5sums` to verify transfers are correct.

