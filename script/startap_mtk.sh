echo AP > /dev/wmtWifi
sleep 1
echo "Enable ap0 interface ..."
ifconfig ap0 up
ifconfig ap0 10.10.10.254 netmask 255.255.255.0
echo "Enable udhcpd ..."
mkdir -p /var/lib/misc
touch /var/lib/misc/udhcpd.leases
udhcpd /data/vbd_workdir/common/wifi/udhcpd.conf &
sleep1
echo "Enable HOSTAPD ..."
hostapd -dd /data/vbd_workdir/common/wifi/hostapd_mtk.conf &
