# SSH setting
The following command allows a modern distribution (Fedora 42 in my case) to connect to the TP-Link ER605 v2 which uses older deprecated SSH settings.

> [!WARNING] 
> **Use at your own risk. Your device may become bricked if you do something wrong or as a result of a bug.** It is assumed that you understand what these commands do and what you are doing.

Download [`openssl.cnf`](openssl.cnf) and run:
```shell
OPENSSL_CONF=./openssl.cnf ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa admin@192.168.0.1
```

Sample output for a ER605 v2.20, Firmware Version: 2.2.5 Build 20240522 Rel.75860
```
$ OPENSSL_CONF=./openssl.cnf ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa admin@192.168.0.1
admin@192.168.0.1's password: 

>ena

#debug
Enter your password: 

BusyBox v1.22.1 (2024-05-22 18:49:25 CST) built-in shell (ash)
Enter 'help' for a list of built-in commands.

  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 BARRIER BREAKER (Barrier Breaker, unknown)
 -----------------------------------------------------
  * 1/2 oz Galliano         Pour all ingredients into
  * 4 oz cold Coffee        an irish coffee mug filled
  * 1 1/2 oz Dark Rum       with crushed ice. Stir.
  * 2 tsp. Creme de Cacao
 -----------------------------------------------------
root@ER605:/# 
```