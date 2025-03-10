#!/bin/sh
# Create SSH keys with passphrase
passphrase=$(./utils/generate-pass.sh)
ssh-keygen -t ed25519 -a 16 -q -N "$passphrase" -f ~/.ssh/id_ed25519
echo "passphrase proetecting key is: $passphrase"
echo "$passphrase" >> keypass.log
echo "Press enter if you have noted down the passphrase"
read line
