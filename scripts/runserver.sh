#!/bin/sh
date -u
echo "running server: $1"
case "$1" in
  official|dev)
    cd "${HOME}/redeclipse-${1}"
    git pull
    git submodule foreach 'git pull'
    RE_RUN_VER=`git rev-parse HEAD`
    make -C src clean-server
    make PLATFORM_BUILD="$(date '+%s')" PLATFORM_BRANCH="master" PLATFORM_REVISION="${RE_RUN_VER}" WANT_DISCORD=1 WANT_STEAM=1 -j4 -C src server
    while true; do
      make -C src install-server
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
