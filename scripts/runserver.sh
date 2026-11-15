#!/bin/sh
date -u
echo "running server: $1"
case "$1" in
  official)
    cd "${HOME}/redeclipse-${1}" || exit 1
    # runupdate.sh builds in this same checkout, so pulling, building and installing take turns with it
    RE_LOCK="${HOME}/logs/build-${1}.lock"
    (
      flock 9
      RE_CUR_VER=`git rev-parse HEAD`
      git pull
      RE_RUN_VER=`git rev-parse HEAD`
      echo "${1}: ${RE_CUR_VER} -> ${RE_RUN_VER}"
      if ! ls src/redeclipse_server* >/dev/null 2>&1 || { [ -n "${RE_RUN_VER}" ] && [ "${RE_CUR_VER}" != "${RE_RUN_VER}" ]; }; then
        git submodule update --init --recursive
        make -C src clean-server
        make PLATFORM_BUILD="$(date '+%s')" PLATFORM_BRANCH="master" PLATFORM_REVISION="${RE_RUN_VER}" WANT_DISCORD=0 WANT_STEAM=0 -j4 -C src server && echo "${RE_RUN_VER}" > "${HOME}/logs/built-${1}"
      fi
    ) 9>"${RE_LOCK}"
    RE_WAIT=5
    while true; do
      ( flock 9; make -C src install-server ) 9>"${RE_LOCK}"
      RE_START=`date '+%s'`
      REDECLIPSE_HOME="${HOME}/master/${1}" REDECLIPSE_BINARY=redeclipse_server ./redeclipse.sh -sg0 -g 2>&1 | tee --append "${HOME}/logs/server-${1}.log"
      # a server that keeps stopping straight away waits longer each time, up to five minutes, rather than filling the log
      if [ $((`date '+%s'` - RE_START)) -lt 60 ]; then RE_WAIT=$((RE_WAIT * 2)); [ ${RE_WAIT} -gt 300 ] && RE_WAIT=300; else RE_WAIT=5; fi
      echo "${1}: stopped, starting again in ${RE_WAIT}s"
      sleep ${RE_WAIT}
    done
    cd "${HOME}"
    ;;
  rehash)
    for i in official; do
        j=`pgrep -u "$(id -u)" -f "redeclipse-${i}/bin/"`
        if [ -n "${j}" ]; then kill -s HUP ${j}; fi
    done
    ;;
esac
echo "done."
