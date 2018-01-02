#!/bin/bash

set -x

if ( /usr/sbin/squid -k parse ); then
  echo Parsing complete
  if ( /usr/sbin/squid -z ); then
    echo Created cache_dir
    sleep 60
    if ( /usr/sbin/squid -sNd2F --enable-cache-digests --enable-htcp --enable-icmp --enable-async-io ); then
       echo Exited squid
# for debugging purposes only
       cat /var/log/squid/*
    fi
  fi
fi
