#!/bin/bash

CONF="$1"
APP="$2"
INVALID="$3"
if ! [ -z "$INVALID" ]; then
  echo "Only two arguments supported"
  exit 1
fi
INVALID="0"

# usage: ./replace_conf.sh /etc/app/app.conf APP
# first parameter is path to config file
# second parameter is environment variabel to use for replacement in the config file

# set up env
set -x # print loops
set -e # exit immediately on bg job errors
#set -u # exit on unset vars, like empty configs, no env var etc
set -v # debugging

# read the config as an array
while read -r line; do 
  CONFDATA+=($line) 
done < "$CONF"

# variable names to shorten references
KEYAWK="/usr/bin/awk -f /usr/local/bin/key.awk"
VALUEAWK="/usr/bin/awk -f /usr/local/bin/value.awk"


# array push the env vars based on $APP match
while read -r line; do
  ENVCONF+=($line)
done < "$(env | grep "$APP")"

# for each line, replace if match $APP match in config array $CONFDATA
for i in "${CONFDATA[@]}"; do
  for y in "${ENVCONF[@]}"; do
     if [[ ${ENVCONF[$y]} =~ .*$APP.* ]]; then
      CONFDATA[$i]=$(echo -e "${ENVCONF[@]}" | sed s/"$(echo -e "$i" | $KEYAWK)"/"$(echo -e "$i" | $VALUEAWK)"/g)
    fi
  done
done

# debug check if its ok after this
for i in "${CONFDATA[@]}"; do
  echo -e "${CONFDATA[$i]}"
done

#clear out all comments and write to file
for i in "${CONFDATA[@]}"; do
  ${${CONFDATA[$i]}//^#.*//} > "$CONF"
done


echo "Script ran for $SECONDS seconds"
