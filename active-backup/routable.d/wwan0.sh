#!/bin/bash

if [ "$IFACE" == "wwan0" ];
then
  echo "$IFACE became routable, check wlan0 status"
  if networkctl | grep wlan0 | grep -q routable; then
    echo "wlan0 is already routable, taking wwan0 down"
    ip link set wwan0 down
  else
    echo "wlan0 is NOT routable, leaving $IFACE up"
  fi
fi
