#!/bin/bash

# release the ip: MacOS only
echo "Resetting IP on en0..."
sudo ipconfig set en0 BOOTP
sleep 4
sudo ipconfig set en0 DHCP
echo "Network refreshed."
