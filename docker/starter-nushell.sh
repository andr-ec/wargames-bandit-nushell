#!/bin/bash
# Starter script for Nushell Bandit Wargame
# Starts background services and SSH daemon

# Start Python listeners for network levels
python3 /etc/bandit_scripts/script14.py &>/dev/null &
python3 /etc/bandit_scripts/script15.py &>/dev/null &
python3 /etc/bandit_scripts/script16.py &>/dev/null &
python3 /etc/bandit_scripts/script25.py &>/dev/null &

# Start cron jobs
sudo -u bandit22 /usr/bin/cronjob_bandit22.sh &>/dev/null &
sudo -u bandit23 /usr/bin/cronjob_bandit23.sh &>/dev/null &
sudo -u bandit24 bash -c 'while sleep 60; do /usr/bin/cronjob_bandit24.sh; done' &>/dev/null &
sudo -u bandit35 bash -c 'while sleep 60; do /usr/bin/cronjob_bandit35.sh; done' &>/dev/null &

# Start SSH daemon in foreground
/usr/sbin/sshd -D

wait -n
exit $?
