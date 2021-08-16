#!/bin/bash

CA_PATH=${CA_PATH:-/home/amaier/main_ca}
PLOT_PATH=${PLOT_PATH:-/mnt/plots}
EC_NODE=${EC_NODE:-ec-full0}

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
create_args
docker build --build-arg hostname=$HOSTNAME -t harvester:latest .
docker run --name harvester0 -d --restart always ${mount_args[@]} -t harvester:latest ${run_args[@]}

