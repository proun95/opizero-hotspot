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
	echo "6. Exit"
	read -p 'Choose item: ' item
	clear
	
	if [ $item -eq 1 ]
	then
		sudo chmod +x /home/orangepi/opizero-hotspot/add_wlan.sh
		sudo chmod +x /home/orangepi/opizero-hotspot/add opizero-hotspot.sh
		sudo chmod +x /home/orangepi/opizero-hotspot/add launch_hotspot.sh
		sudo echo "alias opihotspot='/home/orangepi/opizero-hotspot/add opizero-hotspot.sh'"
		sudo source /home/orangepi/.bashrc
		sudo cp -f /home/orangepi/opizero-hotspot/launch_hotspot.service /etc/systemd/system/launch_hotspot.service
		sudo cp -f /home/orangepi/opizero-hotspot/launch_hotspot.timer /etc/systemd/system/launch_hotspot.timer
		sudo systemctl daemon-reexec
		sudo systemctl daemon-reload
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
		sudo bash /home/orangepi/opizero-hotspot/add_wlan.sh

	elif [ $item -eq 5 ]
	then
		rm -v /etc/netplan/90*

	elif [ $item -eq 6 ]
	then
		exit
	fi
	sleep 2

done