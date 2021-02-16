# BONDING does not sem to work with sim7600gh



https://www.raspberrypi.org/forums/viewtopic.php?t=224355


http://linux-ip.net/html/adv-multi-internet.html




https://kerlilow.me/blog/setting-up-systemd-networkd-with-bonding/
https://wiki.debian.org/Bonding

## Build bonding module

> Make sure to follow README.md in this repo root first

Edit .config and make sure you have:
```
CONFIG_LOCALVERSION="-tegra"
CONFIG_BONDING=m
```
Run:
```
cd /lib/modules/$(uname -r)/build
make modules_prepare
cd drivers/net/bonding/
make ARCH=arm64 -C /lib/modules/$(uname -r)/build M=$(pwd)
mkdir -p /lib/modules/$(uname -r)/kernel/drivers/net/bonding
cp /lib/modules/$(uname -r)/build/drivers/net/bonding/bonding.ko /lib/modules/$(uname -r)/kernel/drivers/net/bonding/
depmod -a
modprobe bonding
lsmod | grep bonding
```

```shell script
vi /etc/modules
```

```shell script
# bonding module
bonding
```































CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m

cd drivers/net/bonding


make ARCH=arm64 -C /lib/modules/$(uname -r)/build M=$(pwd)



sudo ./source_sync.sh -k tegra-l4t-r32.1

sudo -s

cd /usr/lib/$(uname -r)/

rm build

ln -s /usr/src/sources/kernel/kernel-4.9/ build

cd /usr/src/sources/kernel/kernel-4.9/

sudo -s

cp /proc/config.gz .

gunzip config.gz

mv config .Config

# Edit and make sure you have CONFIG_LOCALVERSION="-tegra" #(i skipped this one)

make nconfig

make modules_prepare
cd drivers/net/bonding/
make ARCH=arm64 -C /lib/modules/$(uname -r)/build M=$(pwd)
mkdir -p /lib/modules/$(uname -r)/kernel/drivers/net/bonding
cp /lib/modules/$(uname -r)/build/drivers/net/bonding/bonding.ko /lib/modules/$(uname -r)/kernel/drivers/net/bonding/
depmod -a
modprobe bonding
lsmod | grep bonding