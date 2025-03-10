# Project resouce Reference

## server.sh
### Code: BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#### Resouce found in: https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script

## exec-map.sh
### code: ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}/\d+'
#### Resourse found in https://stackoverflow.com/questions/8529181/which-terminal-command-to-get-just-ip-address-and-nothing-else

## mosh.sh
#### Resourse found in https://firewalld.org/documentation/howto/add-a-service.html

## create-keys.sh, setup-auth.sh
##### Related Commands: ssh-keygen, ssh-copy-id, and others
#### Resource found in: https://builtin.com/articles/ssh-without-password

## test-remote.sh
### code: status=$(ssh -o BatchMode=yes -o ConnectTimeout=5 user@host echo ok 2>&1)
#### Resourse found in https://stackoverflow.com/questions/1405324/how-to-create-a-bash-script-to-check-the-ssh-connection

## nginx.sh
#### Resource found in https://phoenixnap.com/kb/nginx-start-stop-restart


