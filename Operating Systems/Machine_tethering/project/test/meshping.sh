#!/bin/bash

#installing nmap to use it for seeing which port are up in the network

sudo apt install nmap

# We use the pipe so that on the output we can use grep to do pattern matching after extracting the ips we redirect and store the result in ip.txt.

nmap -sn 192.168.10.0/24 | grep -o 192.168.10.* > ip.txt

#This is a built in command which maps each line of the ip.txt to an index of arrayip
readarray -t arrayip <ip.txt

#we use for loop over how much elements ib=n the array
for ((i=0; i<${#arrayip[@]}; i++)); do

	#will only send 4 packet to the destination ip address and store in /dev/null we do this as we dont want the out we just want to see if the ping was successful
	#we check this in the if statement
	ping -c 4 ${arrayip[i]} > /dev/null

	#checks if previous process was successful so will show Ping was successful
	if [[ $? -eq 0 ]]; then
		current_date=$(date +"%Y-%m-%d %H:%M:%S")
    	echo -e "$current_date Connectivity with ${arrayip[i]} is ok\n" 

    	#storing the result in network.log file so we know which Ping were successful and here we are appending to the file.
    	echo -e "$current_date Connectivity with ${arrayip[i]} is ok\n" >> networks.log
			
	else
		val=${arrayip[i]}

		#exporting the ip address in Val so we can use it in traceroute script
		export val

		#calling traceroute script
		./traceroute.sh

	fi


done



