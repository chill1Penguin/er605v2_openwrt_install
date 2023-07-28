# Credit goes to richh for figuring this out
# https://forum.openwrt.org/t/looking-for-info-and-possibility-of-future-support-of-tp-link-omada-er605-router/91868/39

import hashlib

print("Enter the MAC address found on the bottom of your ER605 using the format AA:BB:CC:DD:EE:FF or AA-BB-CC-DD-EE-FF.\nMAC address: ", end="")
mac = input().replace("-", ":").upper()

print("Enter the username used to login to the web configuration GUI: ", end="")
un = input()

print("The root password is: " + hashlib.md5((mac + un).encode('utf-8')).hexdigest()[:16])

