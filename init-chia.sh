#!/bin/bash

. ./activate
chia init -c /opt/main-ca/
chia init
sed -i 's/\*self_hostname/eid-chia-plotter-mk1/2' ~/.chia/mainnet/config/config.yaml

chia plots add -d /plots
chia start harvester
