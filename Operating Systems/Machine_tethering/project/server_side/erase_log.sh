#!/usr/bin/env bash

# installing cron to do scheduled tasks/processes/script runs
sudo apt update
sudo apt install cron

# enabling cron
sudo systemctl enable cron

# command to add the erase_log_command.sh to crontab to run in the background
(crontab -l 2>/dev/null; echo "0 12 * * 1 cd ~/Desktop/OS_Project/project/server_side/ && ./erase_log_command.sh") | crontab -

#for every week:
# 0 12 * * 1

#for every minute (testing only)
#* * * * *
