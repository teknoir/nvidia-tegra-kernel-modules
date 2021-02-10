/etc/wpa_supplicant/wpa_supplicant-wlan0.conf
```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
eapol_version=1
country=SE
network={
	mode=2
	ssid="teknoirwifi"
	proto=RSN WPA
	key_mgmt=WPA-PSK
	psk="TNEdge-v1.0"
}
```

/etc/systemd/network/30-wifi.network
```
[Match]
Name=wlan0

[Network]
Address=192.168.4.1/24
MulticastDNS=yes
DHCPServer=yes

[DHCPServer]
DNS=8.8.8.8 8.8.4.4
```

/etc/network/interfaces
```
iface wlan0 inet manual
```



Reserve IP:
```
sudo apt-get install isc-dhcp-server
```

/etc/dhcp3/dhcpd.conf
```
host Accountant {
hardware ethernet 00:1F:6A:21:71:3F;
fixed-address 10.0.0.101;
}
```