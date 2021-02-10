# Guide on how to install kernel module for SIM7600G-H_4G_for_Jetson_Nano

## Preparations to build module
Create the “source_sync.sh” on the Jetson at “/usr/src”.
Run this to get full source:
```shell script
sudo su
apt-get install bc
source_sync.sh -k tegra-l4t-r32.1
```

Now you will have “/usr/src/sources/kernel/kernel-4.9”. Copy the “/proc/config.gz” there, gunzip it, rename as “.config”, set CONFIG_LOCALVERSION="-tegra" (or whatever your current “uname -r” suffix is), and then update the symbolic link in “/lib/modules/$(uname -r)/”:
```shell script
cp /proc/config.gz /usr/src/sources/kernel/kernel-4.9/
cd /usr/src/sources/kernel/kernel-4.9
gunzip config.gz
mv config .config
vi .config
```

Update the symbolic link:
```shell script
cd /lib/modules/$(uname -r)
rm build
ln -s /usr/src/sources/kernel/kernel-4.9 build
cd build
sudo make modules_prepare
```
At this point you will have a guaranteed full source with any relative paths going outside of the tree also being there. If you want to switch back to the default headers just point the sym link back to the original headers directory.

## Build and install module
SSH to the device and build the module:
```shell script
mkdir -p ~/Simcom_wwan
cd ~/Simcom_wwan
wget https://www.waveshare.com/w/upload/4/46/Simcom_wwan.zip
tar zxvf Simcom_wwan.zip
cd Simcom_wwan
sudo make
make -C /lib/modules/`uname -r`/build M=$PWD
```

```shell script
cp simcom_wwan.ko /lib/modules/$(uname -r)/kernel/drivers/net/usb
depmod
modprobe simcom_wwan
```

```shell script
vi /etc/modules
```

```shell script
# simcom wwan module
simcom_wwan
```

## Configure and make it connect at boot
Add netplan config:
```
sudo tee -a /etc/netplan/wwan0.yaml > /dev/null <<EOT
network:
  version: 2
  renderer: networkd
  ethernets:
    wwan0:
      dhcp4: true
EOT
```

Add udev rule and script to connect to 4G:
```
sudo tee -a /etc/udev/rules.d/99-usb-4g.rules >> /dev/null <<EOT
SUBSYSTEM=="tty", KERNEL=="ttyUSB3", RUN+="/usr/local/bin/connect_usb_4g.sh"
EOT
```

```
sudo tee -a /usr/local/bin/connect_usb_4g.sh > /dev/null <<EOT
#!/usr/bin/env bash
#echo 'AT+CPIN=1111' > /dev/ttyUSB3
#echo 'AT+CGDCONT=1,"IP","Broadband"' > /dev/ttyUSB3
echo 'AT\$QCRMCALL=1,1\r' > /dev/ttyUSB3

EOT
sudo chmod +x /usr/local/bin/connect_usb_4g.sh
```

```
sudo tee -a /usr/local/bin/connect_usb_4g.sh > /dev/null <<EOT
#!/usr/bin/env bash

echo -e 'AT+CNMP=2\r' > /dev/ttyUSB2
sleep 1
echo -e 'AT$QCRMCALL=1,1\r' > /dev/ttyUSB2
sleep 5
IP=$(/sbin/ifconfig wwan0 | grep 'inet ' | awk '{ print $2}')

while [ -z $IP ]
do
  sleep 30
  echo -e 'AT+CNMP=2\r' > /dev/ttyUSB2
  sleep 1
  echo -e 'AT$QCRMCALL=1,1\r' > /dev/ttyUSB2
  IP=$(/sbin/ifconfig wwan0 | grep 'inet ' | awk '{ print $2}')
done
EOT
sudo chmod +x /usr/local/bin/connect_usb_4g.sh
```


Resources: 
 * https://www.waveshare.com/wiki/SIM7600G-H_4G_for_Jetson_Nano
 * https://forums.developer.nvidia.com/t/errror-executing-modules-prepare/75654
 * https://github.com/phillipdavidstearns/simcom_wwan-setup


