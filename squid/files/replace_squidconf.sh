#!/bin/bash
# set up env
set -e
execpath="/usr/local/bin"

# get all the squidvars
squidenv="$(env | grep SQUID)"

# for each squidvar, replace them in the file
for i in squidenv; do
  sed s/$(echo $i | awk -f $execpath/key.awk)/$(echo $i | awk -f $execpath/value.awk)/g
done

#clear out all comments
sed s/^#.*$//g /etc/squid/squid.conf > /etc/squid/squid.conf.temp
cat /etc/squid/squid.conf.temp > /etc/squid/squid.conf
