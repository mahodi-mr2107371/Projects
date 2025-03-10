#!/bin/sh
# Check if a command is installed and install its package if not
command_name=$1
package_name=$2

if ! command -v $command_name >/dev/null 2>&1; then
    sudo dnf install -y $package_name
fi
