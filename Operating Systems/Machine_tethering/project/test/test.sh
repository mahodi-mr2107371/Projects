#!/bin/bash

if [x = true]; then
    ./meshping.sh;
    x = false;
else
    current_date=$(date +"%Y-%m-%d")
    echo "$current_date" + "Connectivity with $ip is ok" 
fi
