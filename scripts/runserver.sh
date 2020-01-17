#!/bin/sh
date -u
echo "running server: $1"
case "$1" in
  official|dev)
    cd "${HOME}/redeclipse-${1}"
    while true; do
      rm -vf "../bins.tar.gz"
      curl -o "../bins.tar.gz" "https://github.com/redeclipse/deploy/raw/master/master/linux.tar.gz" && tar -zxvf "../bins.tar.gz"
      REDECLIPSE_HOME="${HOME}/master/${1}" REDECLIPSE_BINARY=redeclipse_server ./redeclipse.sh -sg0 -g 2>&1 | tee --append "${HOME}/logs/server-${1}.log"
      sleep 10
    done
    ;;
  rehash)
    for i in official dev; do
        j=`pgrep -f "redeclipse-${i}"`
        if [ -n "${j}" ]; then kill -s HUP ${j}; fi
    done
    ;;
esac
echo "done."
cd "${HOME}"
