#!/bin/sh
date -u
echo "running server: $1"
case "$1" in
  official|dev)
    cd "${HOME}/redeclipse-${1}"
    while true; do
      make -j4 -C src clean-server install-server
      REDECLIPSE_HOME="${HOME}/master/${1}" REDECLIPSE_BINARY=redeclipse_server ./redeclipse.sh -sg0 -g 2>&1 | tee --append "${HOME}/logs/server-${1}.log"
      sleep 5
    done
    cd "${HOME}"
    ;;
  rehash)
    for i in official dev; do
        j=`pgrep -f "redeclipse-${i}"`
        if [ -n "${j}" ]; then kill -s HUP ${j}; fi
    done
    ;;
esac
echo "done."
