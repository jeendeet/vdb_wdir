#!/bin/bash

nohup wpa_cli -iwlan0 -p/tmp/wpa_supplicant DISCONNECT
nohup wpa_cli -iwlan0 -p/tmp/wpa_supplicant remove_network all
nohup wpa_cli -iwlan0 -p/tmp/wpa_supplicant add_network
nohup wpa_cli -iwlan0 -p/tmp/wpa_supplicant set_network 0 ssid '"'"$1"'"'
nohup wpa_cli -iwlan0 -p/tmp/wpa_supplicant set_network 0 psk '"'"$2"'"'
nohup wpa_cli -iwlan0 -p/tmp/wpa_supplicant set_network 0 key_mgmt WPA-PSK
nohup wpa_cli -iwlan0 -p/tmp/wpa_supplicant select_network 0
sleep 2
dhcpcd wlan0

a=0
while [ $a -lt 10 ]
do
	sleep 2
	echo $a
    	a=`expr $a + 1`
	nohup wpa_cli -iwlan0 -p/tmp/wpa_supplicant status
	STATE=$(wpa_cli -iwlan0 -p/tmp/wpa_supplicant status | awk -F = '{if($0 ~ /wpa_state/) print $2}')
	# echo "$STATE"
	if echo "$STATE" | grep -q "4WAY_HANDSHAKE"; then
   		echo "WRONG_KEY"
		break
	elif echo "$STATE" | grep -q "COMPLETED"; then
		IS_IPADD=$(wpa_cli -iwlan0 -p/tmp/wpa_supplicant status)
		if echo "$IS_IPADD" | grep -q "ip_address"; then
			if ping -c 1 8.8.8.8; then
				echo "INTERNET_READY"
				a=0
				exit 0
			else
				wpa_cli -iwlan0 -p/tmp/wpa_supplicant DISCONNECT
				wpa_cli -iwlan0 -p/tmp/wpa_supplicant remove_network all
				echo "NO_INTERNET"
				exit 1
			fi
		fi
	fi
done

if [ $a -eq 10 ]; then
	wpa_cli -iwlan0 -p/tmp/wpa_supplicant DISCONNECT
	wpa_cli -iwlan0 -p/tmp/wpa_supplicant remove_network all
    	echo "CANNOT_CONNECTED"
fi
