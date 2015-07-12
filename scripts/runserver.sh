#!/bin/sh
date
echo "running server: $1"
case "$1" in
  master)
    pushd "${HOME}/redeclipse-master"
    while [ 0 != 1 ]; do
      REDECLIPSE_BRANCH=stable REDECLIPSE_HOME=home/master REDECLIPSE_BINARY=redeclipse_server ./redeclipse.sh 2>&1 | tee "${HOME}/logs/master.log"
      sleep 10
    done
    popd
    ;;
  elara)
    pushd "${HOME}/redeclipse-master"
    while [ 0 != 1 ]; do
      cp -v bin/amd64/redeclipse_server_linux bin/amd64/redeclipse_elara_linux
      REDECLIPSE_BRANCH=inplace REDECLIPSE_HOME=home/elara REDECLIPSE_BINARY=redeclipse_elara ./redeclipse.sh 2>&1 | tee "${HOME}/logs/elara.log"
      sleep 10
    done
    popd
    ;;
  rehash)
    killall -HUP redeclipse_server_linux
    killall -HUP redeclipse_elara_linux
    ;;
esac
echo "done."
