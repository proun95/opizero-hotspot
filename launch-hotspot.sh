#!/bin/bash

sudo cp -f /home/orangepi/opizero-hotspot/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf

systemctl restart NetworkManager

sleep 10

touch /home/orangepi/opizero-hotspot/wlan.conf
nmcli -t -f SSID dev wifi list --rescan yes > /home/orangepi/opizero-hotspot/wlan.conf

if nmcli -t -f DEVICE,STATE device | grep -q '^wlan0:connected$'; then
    echo "wlan0 connected"
else
    echo "wlan0 diconnected, turn hotspot on"
        sudo create_ap -m nat wlan0 end0 'RotorHazard' '12345678' --no-virt
        sleep 20
fi