#!/bin/bash

#this script categorizes APs by their OUI - Organizationally Unique Identifier
    # it is usefull to see which APs are connected to which router
    # with this knowladge we can figure out the model of router from the OUI then check if it has any vulnerabilities

# Check for root privileges
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

mode=$(iwconfig $interface 2>/dev/null | grep "Mode" | awk '{print $4}' | cut -d ':' -f 2)

airodump() {
    airodump-ng wlan0 -w output --output-format csv &
    AIRDUMP_PID=$! 
    sleep 10
    awk -F, '/^[[:space:]]*([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}/{print $1 "," $14}' output-01.csv | sort -t, -k1,1 > sorted_ssids.csv
    kill $AIRDUMP_PID 
}

#issue-1
    # mode parsing correctly gets the `monitor` but it cannot get `managed` instead it gets Not-Associated
    # so i have to type it as if [ "$mode" == "Not-Associated" ]; then
    # instead of if [ "$mode" == "Managed" ]; then

#issue1.2
    # if scripts starts with interace mode monitor there is no problem it will run then see that mode is monitor so it will skip the if statement
    # however if it starts with managed mode it will assign the mode as `not-associated` because of that at the end it wont equal mode=monitor and it wont switch the monitor to maanged
#issue1.2 fix
    # i put mode=Monitor at the end of the check_mode_if_managed_set_monitor

check_mode_if_managed_set_monitor() {
    echo "Current mode of $interface: $mode"
    if [ "$mode" == "Not-Associated" ]; then
        echo "Switching $interface to monitor mode."
        ip link set $interface down
        iwconfig $interface mode monitor
        ip link set $interface up
        echo "$interface is now in monitor mode."
        mode="Monitor"
    fi
}

get_Data() {
    echo "Categorized SSIDs by Router Manufacturer (OUI):"
    awk -F, '{
        oui = substr($1, 1, 8);
        if (oui != current_oui) {
        current_oui = oui;
        print "\nOUI: " oui;
        }
        print "  - " $2 " (" $1 ")";
    }' sorted_ssids.csv
}

check_mode_if_monitor_set_managed() {
    echo "Current mode of $interface: $mode"
    if [ "$mode" == "Monitor" ]; then
        echo "Switching $interface to managed mode."
        ip link set $interface down
        iwconfig $interface mode managed
        ip link set $interface up
        echo "$interface is now in managed mode."
        systemctl restart NetworkManager
    fi
}

#Main

echo "Available network interfaces:"
ip link show | awk -F: '$0 !~ "lo|^[^0-9]"{print $2;getline}'
read interface
check_mode_if_managed_set_monitor
airodump
get_Data
check_mode_if_monitor_set_managed
rm -f output-*.csv sorted_ssids.csv
