#!/bin/bash

CA_PATH=${CA_PATH:-$HOME/main_ca}
PLOT_PATH=${PLOT_PATH:-/mnt/plots}
EC_NODE=${EC_NODE:-ec-full0}
PING_URL=${PING_URL:-N/A}
DISCORD_URL=${DISCORD_URL:-N/A}

create_args() {
	plot_folders=( `find $PLOT_PATH -type d` )
	mount_args=( "-v $CA_PATH:/opt/main_ca" )
	run_args=( "$EC_NODE" )
	index=0
	for i in ${plot_folders[@]}; do
		mount_args+=("-v $i:/d$index")
		run_args+=("/d$index")
		index=$((index+1))
	done
}
if [ $PING_URL == "N/A" ]; then
	echo "ERROR: you must supply a PING_URL"
	exit 1
fi
if [ $DISCORD_URL == "N/A" ]; then
	echo "ERROR: you must supply a DISCORD_URL"
	exit 1
fi
create_args
docker build --build-arg hostname=$HOSTNAME --build-arg discord_url=$DISCORD_URL --build-arg ping_url=$PING_URL -t harvester:latest .
docker run --name harvester0 --rm -d ${mount_args[@]} -t harvester:latest ${run_args[@]}

