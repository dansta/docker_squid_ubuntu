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

CONF="$1"
CONFDATA="$(cat $CONF)"
KEYAWK="/usr/bin/awk -f /usr/local/bin/key.awk"
VALUEAWK="/usr/bin/awk -f /usr/local/bin/value.awk"


# get all the vars
ENVCONF="$(env | grep $2)"

# for each squidvar, replace them in the file
for i in $ENVCONF; do
  CONFDATA="$(echo -e "$CONFDATA" | sed s/"$(echo $i | $KEYAWK)"/"$(echo $i | $VALUEAWK)"/g )"
done

#clear out all comments and write to file
echo -e $CONFDATA | sed /^#.*$/d > "$CONF"

