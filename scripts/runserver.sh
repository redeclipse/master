#!/bin/sh
date -u
echo "running server: $1"
case "$1" in
  official)
    cd "${HOME}/redeclipse-${1}"
    RE_CUR_VER=`git rev-parse HEAD`
    git pull
    RE_RUN_VER=`git rev-parse HEAD`
    echo "${1}: ${RE_CUR_VER} -> ${RE_RUN_VER}"
    if ! ls src/redeclipse_server* >/dev/null 2>&1 || { [ -n "${RE_RUN_VER}" ] && [ "${RE_CUR_VER}" != "${RE_RUN_VER}" ]; }; then
      git submodule update --init --recursive
      make -C src clean-server
      make PLATFORM_BUILD="$(date '+%s')" PLATFORM_BRANCH="master" PLATFORM_REVISION="${RE_RUN_VER}" WANT_DISCORD=0 WANT_STEAM=0 -j4 -C src server
    fi
    while true; do
      make -C src install-server
      REDECLIPSE_HOME="${HOME}/master/${1}" REDECLIPSE_BINARY=redeclipse_server ./redeclipse.sh -sg0 -g 2>&1 | tee --append "${HOME}/logs/server-${1}.log"
      sleep 5
    done
    cd "${HOME}"
    ;;
  rehash)
    for i in official; do
        j=`pgrep -f "redeclipse-${i}"`
        if [ -n "${j}" ]; then kill -s HUP ${j}; fi
    done
    ;;
esac
echo "done."
