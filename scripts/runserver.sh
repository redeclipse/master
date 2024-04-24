#!/bin/sh
date -u
echo "running server: $1"
case "$1" in
  official|dev)
    cd "${HOME}/redeclipse-${1}"
    while true; do
      git pull && git submodule foreach 'git pull'
      rm -vf "../bins.tar.gz"
      curl --connect-timeout 30 -L -k -f -o "../bins.tar.gz" "https://raw.githubusercontent.com/redeclipse/deploy/master/master/linux.tar.gz" && tar -zxvf "../bins.tar.gz"
      curl --connect-timeout 30 -L -k -f -o "../${i}.txt" "https://raw.githubusercontent.com/redeclipse/deploy/master/master/bins.txt"
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
