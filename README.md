# Preparations or building kernel modules for Nvidia Tegra

## Preparations to build module
Create the “source_sync.sh” on the Device at “/usr/src”.
Run this to get full source:
```shell script
sudo su
apt-get install bc
cd /usr/src
./source_sync.sh -k tegra-l4t-r32.1
```

Now you will have “/usr/src/sources/kernel/kernel-4.9”. Copy the “/proc/config.gz” there, gunzip it, rename as “.config”, set CONFIG_LOCALVERSION="-tegra" (or whatever your current “uname -r” suffix is), and then update the symbolic link in “/lib/modules/$(uname -r)/”:
```shell script
cp /proc/config.gz /usr/src/sources/kernel/kernel-4.9/
cd /usr/src/sources/kernel/kernel-4.9
gunzip config.gz
mv config .config
vi .config
```
Enable bonding module
CONFIG_BONDING=y

Update the symbolic link:
```shell script
cd /lib/modules/$(uname -r)
rm build
ln -s /usr/src/sources/kernel/kernel-4.9 build
cd build
sudo make modules_prepare
```

