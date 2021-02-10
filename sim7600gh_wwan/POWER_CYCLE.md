# Guide to install periodical power cycle

We think the culprit is the LTE connection and a power cycle every midnight should at least take us online within a day.

To edit crontab:
```shell script
sudo crontab -e
```

For every midnight, add the line:
```
0 0 * * * /sbin/shutdown -r now
```
see https://en.wikipedia.org/wiki/Cron for a detailed description.

For 00:00 on Sundays:
```
0 0 * * 0 /sbin/reboot
```

# Monitoring IP, and restart

```
[Unit]
Description=SIM7600 NIC %i - keep up at all cost
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=10
StartLimitIntervalSec=0
ExecStartPre=/bin/bash /etc/simcom_wwan/wwan_preup.sh -i %i
ExecStart=/sbin/dhclient -1 %i
ExecStopPost=/bin/bash /etc/simcom_wwan/wwan_postdown.sh -i %i
[Install]
WantedBy=multi-user.target
```

```
sudo tee -a /usr/local/bin/connect_usb_4g.sh > /dev/null <<EOT
#!/usr/bin/env bash

MODULE="simcom_wwan"
IFACE="wwan0"
DEV="ttyUSB2"

function usage {
	echo -e "\nUsage: wann_preup [-d [device]] [-i [interface]]"
	echo -e "NOTE: Some network changes require your password"
	echo -e "\t-d\t\tspecify device (default: /dev/ttyUSB2)"
	echo -e "\t-i\t\tspecify interface (default: wwan0)"
	echo -e "\t-h\t\tdisplay this help message"
	echo -e "\n"
}

while getopts "d:i:h" opt; do
	case ${opt} in
		h)
			usage
			exit 1
			;;
		i)
			IFACE=${OPTARG}
			;;
		d)
			DEV=${OPTARG}
			;;
		:)
			echo "[!] Option requires an argument."
			exit 1
			;;
		\?)
			echo "[!] Invalid option. Run with -h to view usage."
			exit 1
			;;
	esac
done
shift $((OPTIND -1))

if [ "$EUID" -ne 0 ]
  then echo "[!] Please run as root"
  exit 1
fi

/sbin/dhclient -1 %i &


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

Deps for python:
netifaces