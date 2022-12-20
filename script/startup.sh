sleep 10

#killall rootApp
#killall wpa_supplicant

VBD_DIR=/data/vbd_workdir
VBD_COMMON_LIB=$VBD_DIR/lib/common_lib

# common app enable
cd $VBD_DIR/common/mosquitto && LD_LIBRARY_PATH=$VBD_COMMON_LIB ./mosquitto -c mosquitto.conf &

# onboarding wifi
cd $VBD_DIR/onbo_wifi && ./ConnectivityServer 8080 &
cp $VBD_DIR/onbo_wifi/config/wpa_supplicant.conf.bk /etc/wpa_supplicant.conf
source $VBD_DIR/script/startap.sh ViVi_22000003 11 &

# onboarding bluetooth
cd /tmp && LD_LIBRARY_PATH=$VBD_COMMON_LIB $VBD_DIR/onbo_ble/connected_app_ble &

# bluetooth enable
# cd /tmp && LD_LIBRARY_PATH=/opt/sysroot/system_blue_lib /opt/bluetooth/app_manager &

# vRootApp enable
LD_LIBRARY_PATH=/system/workdir/lib /system/workdir/bin/curl 'http://localhost:8080/wifi-connect-request?ssid=VinBigdata-Guest&psk=123456a@'

rm /bkupgrade/vbd_workdir/log/*
# rm -rf /media/sda1/avs_bluetooth/avs_execute/database/*
cp /bkupgrade/vbd_workdir/vbd_avs/avs_execute/sdk-install/deviceId_bk.json /bkupgrade/vbd_workdir/vbd_avs/avs_execute/sdk-install/deviceId.json
# cd /bkupgrade/vbd_workdir/vRootApp && ./vRootApp &

cp /bkupgrade/vbd_workdir/vbd_blue/bt_config.xml /tmp/
cp /bkupgrade/vbd_workdir/vbd_blue/blue_state.json /tmp/
cd /tmp && LD_LIBRARY_PATH=$VBD_COMMON_LIB /bkupgrade/vbd_workdir/vbd_blue/app_manager &
#cd /tmp && LD_LIBRARY_PATH=$VBD_COMMON_LIB /bkupgrade/vbd_workdir/vbd_blue/app_hs_test &
cd /tmp && LD_LIBRARY_PATH=$VBD_COMMON_LIB /bkupgrade/vbd_workdir/vbd_blue/app_avk &

# cd /media/sda1/vivuvivu/SampleApp/src && LD_LIBRARY_PATH=/media/sda1/vivuvivu/libAVS82 ./SampleApp ./AlexaClientSDKConfig.json & 
