#!/bin/bash

NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

while :
do
	clear
	echo "Menu:"
	echo "1. Setup auto hotspot"
	echo "2. Start hotspot"
	echo "3. Stop hotspot/Return WLAN settings"
	echo "4. Add WLAN"
	echo "5. Delete all WLANs"
	echo "6. Remove all settings"
	echo "7. Exit"
	read -p 'Choose item: ' item
	clear
	
	if [ $item -eq 1 ]
	then
		sudo chmod +x /home/orangepi/opizero-hotspot/add-wlan.sh
		sudo chmod +x /home/orangepi/opizero-hotspot/opizero-hotspot.sh
		sudo chmod +x /home/orangepi/opizero-hotspot/launch-hotspot.sh
		sudo echo "alias opihotspot='/home/orangepi/opizero-hotspot/opizero-hotspot.sh'" >> /home/orangepi/.bashrc
		source /home/orangepi/.bashrc
		sudo cp -f /home/orangepi/opizero-hotspot/launch-hotspot.service /etc/systemd/system/launch-hotspot.service
		sudo cp -f /home/orangepi/opizero-hotspot/launch-hotspot.timer /etc/systemd/system/launch-hotspot.timer
		sudo cp -f /home/orangepi/opizero-hotspot/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
		sudo systemctl daemon-reexec
		sudo systemctl daemon-reload
		sudo systemctl enable --now launch-hotspot.timer
		#journalctl -u wifi-check.service
		#systemctl list-timers
		echo "Reboot?"
		echo "1. Yes"
		echo "2. No"
		read -p 'Choose item: ' item
		if [ $item -eq 1 ]
		then
			sudo reboot now
		fi
	
	elif [ $item -eq 2 ]
	then
		if nmcli -t -f DEVICE,STATE device | grep -q '^wlan0:connected$'; then
			echo "wlan0 connected. Disconnect?"
			echo "1. Yes"
			echo "2. No"
			read -p 'Choose item: ' item
			if [ $item -eq 1 ]
			then
				sudo create_ap -m nat wlan0 end0 'RotorHazard' 'qwe1!QWE' --no-virt --daemon
				sleep 10
			fi
		else
			echo "wlan0 diconnected, turn hotspot on"
			sudo create_ap -m nat wlan0 end0 'RotorHazard' 'qwe1!QWE' --no-virt --daemon
			sleep 10
		fi

	elif [ $item -eq 3 ]
	then
		sudo create_ap --stop wlan0
		sleep 10
		sudo cp -f /home/orangepi/opizero-hotspot/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
		sudo systemctl restart NetworkManager
		sleep 10
	
	elif [ $item -eq 4 ]
	then
		sudo bash /home/orangepi/opizero-hotspot/add-wlan.sh

	elif [ $item -eq 5 ]
	then
		sudo rm -v /etc/netplan/90*
		
	elif [ $item -eq 6 ]
	then
		sudo systemctl stop launch-hotspot.timer
		sudo systemctl disable launch-hotspot.timer
		sudo rm /etc/systemd/system/launch-hotspot.service
		sudo rm /etc/systemd/system/launch-hotspot.timer
		sudo cp -f /home/orangepi/opizero-hotspot/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
		sudo systemctl restart NetworkManager
		sudo systemctl daemon-reexec
		sudo systemctl daemon-reload

	elif [ $item -eq 7 ]
	then
		exit
	fi
	sleep 2

done