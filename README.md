
### STEP ONE
Please copy the script below and paste it onto your VPS. Your VPS will reboot by itself after executing the script. Continue in STEP TWO.

```
apt update && apt upgrade -y --fix-missing && update-grub && sleep 2 && reboot
```

### STEP TWO
Please copy the script below and paste it onto your VPS. Type okay is the script ask for answer. After that, Press ENTER for other questions and the system will reboot. After the reboot, execute the script below.

```
sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl && wget https://raw.githubusercontent.com/sunbear88/scvps/main/setup.sh && chmod +x setup.sh && ./setup.sh
```

### SYSTEM NOTE
Enter your VPS and type Menu. Please check the system status using Menu No. 23. If the dropbear/stunnel is not running, execute the script below to fix the problem.

```
./ssh-ssl.sh
```
