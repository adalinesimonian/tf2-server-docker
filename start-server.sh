#!/bin/bash

cpcfg() {
  if [ -f /tf2/cfg/$1 ]; then
    cp /tf2/cfg/$1 /tf2/tf/cfg/$1
  fi
}

if [ ! -f /tf2/cfg/server.cfg ]; then
  G_HOSTNAME="${G_HOSTNAME:-TF2}"
  PORT="${PORT:-27015}"
  SV_PURE="${SV_PURE:-1}"
  MAP="${MAP:-ctf_2fort}"
  MAXPLAYERS="${MAXPLAYERS:-24}"
fi

cpcfg "server.cfg"
cpcfg "mapcycle.txt"
cpcfg "motd.txt"
cpcfg "motd_text.txt"

srcds_args=""

if [ $ARGS ]; then
  srcds_args="${ARGS}"
fi

if [ $PORT ]; then
  srcds_args="${srcds_args} -port ${PORT}"
fi

if [ $G_HOSTNAME ]; then
  srcds_args="${srcds_args} +hostname \"${G_HOSTNAME}\""
fi

if [ $SV_PURE ]; then
  srcds_args="${srcds_args} +sv_pure ${SV_PURE}"
fi

if [ $MAXPLAYERS ]; then
  srcds_args="${srcds_args} +maxplayers ${MAXPLAYERS}"
fi

if [ $MAP ]; then
  srcds_args="${srcds_args} +map ${MAP}"
fi

while true; do
  /tf2/srcds_run -game tf -norestart ${srcds_args}
done

