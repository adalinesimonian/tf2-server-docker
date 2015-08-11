#!/bin/bash

if [ -f /tf2/cfg/mapcycle.txt ]; then
  start_map="/tf2/cfg/mapcycle.txt"
else
  start_map="/home/srcds/tf2/tf/cfg/mapcycle_default.txt"
fi

while read -r line; do
  line=$(echo "$line" | tr -d '\r')
  [[ -z "${line// }" ]] && continue
  [[ "$line" =~ ^//.*$ ]] && continue
  start_map=$line
  break
done < "$start_map"

if [ ! -f /tf2/cfg/server.cfg ]; then
  G_HOSTNAME="${G_HOSTNAME:-TF2}"
  SV_PURE="${SV_PURE:-1}"
fi

PORT="${PORT:-27015}"
MAP="${MAP:-$start_map}"
MAXPLAYERS="${MAXPLAYERS:-24}"

cp -r /tf2/cfg/* /home/srcds/tf2/tf/cfg/

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
  /home/srcds/tf2/srcds_run -game tf -norestart ${srcds_args}
done

