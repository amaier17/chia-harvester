#!/bin/bash

tmux new-session -d 'harvester-mon'
tmux send-keys 'docker exec -it harvester0 tail -f /home/chia/.chia/mainnet/log/debug.log' C-m
tmux split-window -v -p 70
tmux send-keys 'watch -n 2 "df -h --no-sync /mnt/plots/*"' C-m
tmux split-window -v -p 10 -t 1
tmux send-keys 'docker exec -it harvester0 tail -f /home/chia/.chia/mainnet/log/debug.log | grep -i "Found 1"' C-m
tmux -2 attach-session -d

