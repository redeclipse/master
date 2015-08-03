#!/bin/sh
date -u
echo "running server: $1"
case "$1" in
  master|stable)
    pushd "${HOME}/redeclipse-${1}"
    while true; do
      REDECLIPSE_BRANCH=${1} REDECLIPSE_HOME="${HOME}/master/${1}" REDECLIPSE_BINARY=redeclipse_server ./redeclipse.sh -sg0 -g 2>&1 | tee --append "${HOME}/logs/server-${1}.log"
      sleep 10
    done
    popd
    ;;
  statsdb)
    pushd "${HOME}/statsdb-interface"
    while true; do
      ./server.py "${HOME}/master/master" | tee --append "${HOME}/logs/server-statsdb.log"
      sleep 10
    done
    popd
    ;;
  rehash)
    for i in master stable; do
        j=`ps ax | grep "redeclipse-${i}" | grep -v "grep" | sed -e 's/^[ \t]*//g;s/[ \t].*$//'`
        if [ -n "${j}" ]; then kill -s HUP ${j}; fi
    done
    ;;
esac
echo "done."
