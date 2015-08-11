FROM debian:jessie

MAINTAINER Suchipi Izumi "me@suchipi.com"

# Install dependencies

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install lib32gcc1 wget lib32ncurses5
RUN mkdir -p /tf2/cfg

# Set up user

RUN mkdir -p /home/srcds
RUN groupadd -r srcds
RUN useradd -r -g srcds srcds
RUN chown -hR srcds:srcds /home/srcds
USER srcds
WORKDIR /home/srcds

# Install SteamCMD

RUN mkdir steamcmd
WORKDIR /home/srcds/steamcmd
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz

# Get TF2

RUN mkdir /home/srcds/tf2
RUN ./steamcmd.sh +login anonymous +force_install_dir /home/srcds/tf2 +app_update 232250 validate +quit

# Setup Libs for TF2 SRCDS

WORKDIR /home/srcds
RUN mkdir -p .steam/sdk32
RUN cp /home/srcds/steamcmd/linux32/steamclient.so .steam/sdk32/steamclient.so

# Setup Container

ADD start-server.sh /start-server.sh
EXPOSE 27015/udp

VOLUME ["/tf2/cfg"]
CMD ["/bin/bash", "/start-server.sh"]
