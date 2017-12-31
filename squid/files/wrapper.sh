#!/bin/bash

set -x

if ( /usr/sbin/squid -k parse ); then
  echo Parsing complete
  if ( /usr/sbin/squid -z ); then
    echo Created cache_dir
    echo Sleeping 5
    sleep 5
    if ( /usr/sbin/squid -sNd1F ); then
      echo Exited squid
    fi
  fi
fi
