#!/bin/bash

. ./activate
chia init
chia init -c /opt/main-ca/
chia configure --set-farmer-peer ec-full0:8447
chia --log-level INFO

chia plots add -d /plots
chia start harvester
