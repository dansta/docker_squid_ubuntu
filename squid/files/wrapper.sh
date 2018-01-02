#!/bin/bash

set -x

if ( /usr/sbin/squid -k parse ); then
  echo Parsing complete
  if ( /usr/sbin/squid -z ); then
    echo Created cache_dir
    sleep 60
    if ( /usr/sbin/squid -sNd2F ); then
       echo Exited squid
# for debugging purposes only
       cat /var/log/squid/*
    fi
  fi
fi
