FROM ubuntu:20.04
ENV TZ America/Edmonton
ENV DEBIAN_FRONTEND=noninteractive
ARG hostname
ARG ping_url
ARG discord_url

LABEL maintainer="amaier17@gmail.com"
LABEL version="0.1"
LABEL description="This container will create a harvester instance for eid-chia"

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git lsb-release python3 python3-venv sudo
RUN useradd -ms /bin/bash chia
RUN echo "chia ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER chia

COPY ./entrypoint.sh /home/chia/entrypoint.sh

WORKDIR /home/chia
RUN git clone https://github.com/martomi/chiadog.git

WORKDIR /home/chia/chiadog
RUN /bin/bash ./install.sh
COPY ./config.yaml /home/chia/chiadog/config.yaml
RUN sed -i "s|'Chia'|'Chia-$hostname'|;s|PING_URL|$ping_url|;s|DISCORD_URL|$discord_url|" /home/chia/chiadog/config.yaml

WORKDIR /home/chia
RUN git clone https://github.com/Chia-Network/chia-blockchain.git -b 1.2.3

WORKDIR /home/chia/chia-blockchain
RUN sh install.sh


ENTRYPOINT ["bash", "/home/chia/entrypoint.sh"]
