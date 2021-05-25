# Chia Harvester Docker

To start up a harvester only node you will need the following:
- a full node running elsewhere with port 8447 exposed (this script uses ec-full0)
- ~/.chia/mainnet/config/ssl/ca/ directory contents from the full node somewhere accessible
- mount points with the plot(s) to harvest


## Building the docker
First you need to build the docker container:
```
docker build -t harvester:latest .
```

## Running the docker
Launching the docker we need to give it the volumes for the certifications and
the plot mount points.
```
docker run --name harvester0 -d --rm -v "<location of full node ca folder>:/opt/main_ca" -v <plot mount points> -v <plot mount points> -t harvester:latest <pass the internal plot mount points here>
```
For example, let's say we have /mnt/plots/disk0 and /mnt/plots/disk1 with
our plots and our main certificates are at /home/amaier/main_ca:
```
docker run --name harvester0 -d --rm -v "/home/amaier/main_ca:/opt/main_ca" -v "/mnt/plots/disk0:/mnt/plots/disk0" -v "/mnt/plots/disk1:/mnt/plots/disk1" -t harvester:latest /mnt/plots/disk0 /mnt/plots/disk1
```

