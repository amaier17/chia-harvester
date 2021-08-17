# Chia Harvester Docker

To start up a harvester only node you will need the following:
- a full node running elsewhere with port 8447 exposed (this script uses ec-full0)
- ~/.chia/mainnet/config/ssl/ca/ directory contents from the full node somewhere accessible
- mount points with the plot(s) to harvest

## Automated building/running
A start.sh script has been provided here that will search for the correct folders and start the docker. To run this, you simply need to check
some environment variables:
$CA_PATH: The path to the ~/.chia/mainnet/config/ssl/ca directory contents copied from the full node (default: $HOME/main_ca)
$PLOT_PATH: The path to the finished plots parent directory (default: /mnt/plots). It will auto recurse and find all subdirectories with plots
$EC_NODE: The name of the full node (default: ec-full0)
$PING_URL: The healthchecks.io url to get chiadog to ping (see chiadog for more details) (no default)
$DISCORD_URL: The discord integration webhook url for chiadog (see chiadog for more details) (no default)

For the PING_URL AND DISCORD_URL variables, you can set these in /etc/environment to keep them persistent if you wish.

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

