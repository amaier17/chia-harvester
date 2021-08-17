# Chia Harvester Docker

To start up a harvester only node you will need the following:
- a full node running elsewhere with port 8447 exposed (this script uses ec-full0)
- ~/.chia/mainnet/config/ssl/ca/ directory contents from the full node somewhere accessible
- mount points with the plot(s) to harvest


## Building the docker
First you need to build the docker container:
```
docker build --build-arg hostname=$HOSTNAME --build-arg discord_url=<webhook for discord url> ping_url=<webhook for health.io url> -t harvester:latest .
```

## Running the docker
Launching the docker we need to give it the volumes for the certifications and
the plot mount points.
```
docker run --name harvester0 -d --restart always -v "<location of full node ca folder>:/opt/main_ca" -v <plot mount points> -v <plot mount points> -t harvester:latest <IP of the full node> <pass the internal plot mount points here>
```
For example, let's say we have /mnt/plots/disk0 and /mnt/plots/disk1 with
our plots, our main certificates are at /home/amaier/main_ca, and our full node IP/hostname is ec-full0:
```
docker build --build-arg hostname=$HOSTNAME -t harvester:latest .
docker run --name harvester0 -d --restart always -v "/home/amaier/main_ca:/opt/main_ca" -v "/mnt/plots/disk0:/d0" -v "/mnt/plots/disk1:/d1" -t harvester:latest ec-full0 /d0 /d1
```

## Executing status call commands
You can launch commands to the running docker via `docker exec`:

```
docker exec -it harvester0 venv/bin/chia show -s
```
or
```
docker exec -it harvester0 cat /home/chia/.chia/mainnet/log/debug.log
```

## Monitoring the status
This repo contains a monitor.tmux script that will open up some windows for monitoring the harvester.
To run this simply start up a tmux session and `./monitor.tmux` run the script.

