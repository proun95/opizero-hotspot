#!/bin/bash

cat /home/orangepi/opizero-hotspot/wlan.conf

read -p 'Type WLAN name: ' name
read -p 'Type WLAN password: ' password

sudo create_ap --stop wlan0

sleep 10

sudo cp -f /home/orangepi/opizero-hotspot/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf

sudo systemctl restart NetworkManager

sleep 10

touch /home/orangepi/opizero-hotspot/wlan.conf
sudo nmcli -t -f SSID dev wifi list --rescan yes >/home/orangepi/opizero-hotspot/wlan.conf

sudo nmcli dev wifi connect $name password $password

sleep 10

if nmcli -t -f DEVICE,STATE device | grep -q '^wlan0:connected$'; then
    echo "wlan0 connected"
else
    echo "wlan0 diconnected, turn hotspot on"
        sudo create_ap -m nat wlan0 end0 'RotorHazard' 'qwe1!QWE' --no-virt --daemon
        sleep 10
fi