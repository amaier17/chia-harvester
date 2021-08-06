#!/bin/bash

. ./activate
chia init
chia init -c /opt/main_ca/
chia configure --set-farmer-peer $1:8447
chia configure --log-level INFO
sed -i 's/localhost/127.0.0.1/g' ~/.chia/mainnet/config/config.yaml

for var in "${@:2}"
do
	chia plots add -d $var
done

chia start harvester
pushd /home/chia/chiadog
./start.sh &> ~/chiadog.log &

while true; do sleep 30; done;
