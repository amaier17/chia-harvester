#!/bin/bash

. ./activate
chia init
chia init -c /opt/main_ca/
chia configure --set-farmer-peer 192.168.100.206:8447
chia configure --log-level INFO
sed -i 's/localhost/127.0.0.1/g' ~/.chia/mainnet/config/config.yaml

for var in "$@"
do
	chia plots add -d $var
done

chia start harvester

while true; do sleep 30; done;
