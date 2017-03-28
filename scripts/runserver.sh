#!/bin/sh
date -u
echo "running server: $1"
case "$1" in
  official|stable)
    cd "${HOME}/redeclipse-${1}"
    while true; do
      REDECLIPSE_BRANCH=stable REDECLIPSE_HOME="${HOME}/master/${1}" REDECLIPSE_BINARY=redeclipse_server ./redeclipse.sh -sg0 -g 2>&1 | tee --append "${HOME}/logs/server-${1}.log"
      sleep 10
    done
    ;;
  official-nonet|stable-nonet)
    cd "${HOME}/redeclipse-${1}"
    while true; do
      REDECLIPSE_BRANCH=inplace REDECLIPSE_HOME="${HOME}/master/${1}" REDECLIPSE_BINARY=redeclipse_server ./redeclipse.sh -sg0 -g 2>&1 | tee --append "${HOME}/logs/server-${1}.log"
      sleep 10
    done
    ;;
  statsdb)
    cd "${HOME}/statsdb-interface"
    while true; do
      PYTHONUNBUFFERED="yes" ./run.py "${HOME}/master/official" | tee --append "${HOME}/logs/server-statsdb.log"
      sleep 10
    done
    ;;
  rehash)
    for i in official stable; do
        j=`pgrep -f "redeclipse-${i}"`
        if [ -n "${j}" ]; then kill -s HUP ${j}; fi
    done
    ;;
esac
echo "done."
cd "${HOME}"
