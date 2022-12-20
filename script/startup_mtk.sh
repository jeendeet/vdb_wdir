#!/bin/sh
cp /data/vbd_workdir/onbo_wifi/config/wpa_supplicant.conf.bk /etc/wpa_supplicant.conf
rm -rf /data/vbd_workdir/vbd_avs/avs_execute/database/* 
sleep 10
echo "VDB APP INIT..."
echo mode 58 0 > /sys/devices/platform/1000b000.pinctrl/mt_gpio
echo dir 58 1 > /sys/devices/platform/1000b000.pinctrl/mt_gpio
echo out 58 1 > /sys/devices/platform/1000b000.pinctrl/mt_gpio

killall wpa_supplicant
cd /data/vbd_workdir/script && ./startap_mtk.sh
cd /data/vbd_workdir/onbo_wifi && ./ConnectivityServer 8080 &

cd /data/vbd_workdir/vRootApp && ./vRootApp & 


/usr/bin/sled_test &
