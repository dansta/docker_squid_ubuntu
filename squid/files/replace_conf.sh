#!/bin/bash

# usage: ./replace_conf.sh /etc/app/app.conf APP
# first parameter is path to config file
# second parameter is environment variabel to use for replacement in the config file

# set up env
set -x # print loops
set -e # exit immediately on bg job errors
set -u # exit on unset vars
set -v # debugging
if [ -z "$3" ]; then
  echo "Only two arguments supported"
  exit 1
fi

# read the config as an array
CONF="$1"
while read -r line; do 
  CONFDATA+=($line) 
done < "$CONF"

# variable names to shorten references
KEYAWK="/usr/bin/awk -f /usr/local/bin/key.awk"
VALUEAWK="/usr/bin/awk -f /usr/local/bin/value.awk"


# array push the env vars based on $2
while read -r line; do
  ENVCONF+=($line)
done < "$(env | grep "$2")"

# for each line, replace if match $2
for i in "${CONFDATA[@]}"; do
  if [[ ${CONFDATA[$i]} =~ .*$2.* ]] ; then
    CONFDATA[$i]=$(echo "${ENVCONF[@]}" | sed s/"$(echo $i | $KEYAWK)"/"$(echo $i | $VALUEAWK)"/g)
  fi
done

#clear out all comments and write to file
echo "${CONFDATA[@]}" | sed /^#.*$/d > "$CONF"

echo "Script ran for $SECONDS"
