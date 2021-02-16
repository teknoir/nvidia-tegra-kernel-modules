#!/bin/bash

if [ "$IFACE" == "wlan0" ];
then
  echo "$IFACE became routable, taking wwan0 down"
  ip link set wwan0 down
fi