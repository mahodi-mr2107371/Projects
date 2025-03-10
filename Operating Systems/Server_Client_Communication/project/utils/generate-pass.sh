#!/bin/sh
# Generate a secure password using pwgen
./utils/check-install.sh pwgen pwgen
pwgen -s 16 1
