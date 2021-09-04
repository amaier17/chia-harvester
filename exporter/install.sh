#!/bin/bash
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
EXEC_PATH="$SCRIPT_PATH/exporter.py"

cat > /etc/systemd/system/chia-harvester-exporter.service <<- EOM
[Unit]
Description=Prometheus exporter for chia harvesters
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/usr/bin/env python3 $EXEC_PATH

[Install]
WantedBy=multi-user.target
EOM

apt install -y python3-pip
pip3 install -r "$SCRIPT_PATH/requirements.txt"
systemctl daemon-reload
systemctl enable chia-harvester-exporter.service
systemctl start chia-harvester-exporter.service