#!/bin/bash

if [ "$IFACE" == "wlan0" ];
then
  echo "$IFACE lost carrier, bringing wwan0 up"
  ip link set wwan0 up
fi