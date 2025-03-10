#!/bin/bash


# changes the value of ttl to 5 as small network also because default value is 30 so alot of waste space
echo "Running traceroute script on $val"

traceroute -m 5 $val >> networks.log

echo "Rebooting..."
sleep 10
sudo reboot

