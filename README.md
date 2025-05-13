# opizero-hotspot

## Description

This repository contains a collection of Bash scripts designed to simplify Wi-Fi network administration for Orange pi zero 2w (and others). The main functionality includes:
- Automatic detection of available known Wi-Fi networks
- Connection to preferred networks when available
- Automatic creation of a Wi-Fi access point when no known networks are available

## Installation
```
git clone https://github.com/proun95/opizero-hotspot.git
cd opizero-hotspot
```
If you clone to difference directory (default: /home/orangepi/opizero-hotspot) change main directory:
```
sed -i 's|/home/orangepi/opizero-hotspot|YOUR_PATH|g' *
```
If you want to change hotspot SSID or password (default SSID: RotorHazard, password: 12345678):
```
sed -i 's|RotorHazard|YOUR_SSID|g' *
sed -i 's|12345678|YOUR_PASSWORD|g' *
```
## Usage
```
sudo bash opizero-hotspot.sh
```
After setup you can use ```opihotspot``` for launch because alias was added.
