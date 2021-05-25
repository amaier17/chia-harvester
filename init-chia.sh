#!/bin/bash

. ./activate
chia init
chia init -c /opt/main-ca/
chia configure --set-farmer-peer ec-full0:8447
chia --log-level INFO

for var in "$@"
do
	chia plots add -d $var
done

chia start harvester
