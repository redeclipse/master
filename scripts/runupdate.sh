#!/bin/sh
date -u
RE_RUN_SERVERS="official"
RE_RUN_CURHOUR=`date "+%M"`

cd "${HOME}/master" || exit 1
RE_CUR_HOME=`git rev-parse HEAD`
git pull
RE_RUN_HOME=`git rev-parse HEAD`
echo "home: ${RE_CUR_HOME} -> ${RE_RUN_HOME}"
if [ "${RE_CUR_HOME}" != "${RE_RUN_HOME}" ]; then
    for i in ${RE_RUN_SERVERS}; do
        RE_PID=`pgrep -u "$(id -u)" -f "redeclipse-${i}/bin/"`
        if [ -n "${RE_PID}" ]; then
            echo "sending HUP to ${i} (${RE_PID})"
            kill -s HUP ${RE_PID}
        fi
    done
fi
cd "${HOME}"

for i in ${RE_RUN_SERVERS}; do
    echo "${i}: checking.."
    cd "${HOME}/redeclipse-${i}" || continue
    # one at a time, and never while runserver.sh builds or installs in the same checkout
    (
        flock -n 9 || { echo "${i}: a build is already running"; exit 0; }
        git pull
        RE_RUN_VER=`git rev-parse HEAD`
        # against what last built, so a build that failed is tried again rather than waiting for the next commit
        RE_BUILT=`cat "${HOME}/logs/built-${i}" 2>/dev/null`
        echo "${i}: ${RE_BUILT:-nothing built} -> ${RE_RUN_VER}"
        if [ -n "${RE_RUN_VER}" ] && [ "${RE_BUILT}" != "${RE_RUN_VER}" ]; then
            git submodule update --init --recursive
            make -C src clean-server
            if make PLATFORM_BUILD="$(date '+%s')" PLATFORM_BRANCH="master" PLATFORM_REVISION="${RE_RUN_VER}" WANT_DISCORD=0 WANT_STEAM=0 -j4 -C src server; then
                echo "${RE_RUN_VER}" > "${HOME}/logs/built-${i}"
                RE_PID=`pgrep -u "$(id -u)" -f "redeclipse-${i}/bin/"`
                if [ -n "${RE_PID}" ]; then
                    echo "${i}: sending TERM to ${RE_PID}"
                    kill -s TERM ${RE_PID}
                fi
            else
                echo "${i}: the build failed, so the running server stays"
            fi
        fi
    ) 9>"${HOME}/logs/build-${i}.lock"
    cd "${HOME}"
done

echo "-"
