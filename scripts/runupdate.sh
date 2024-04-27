#!/bin/bash
date -u
RE_RUN_SERVERS="official"
RE_RUN_CURHOUR=`date "+%M"`

pushd "/webspace/redeclipse.net"
git pull
popd


pushd "${HOME}/master"
RE_CUR_HOME=`git rev-parse HEAD`
git pull
RE_RUN_HOME=`git rev-parse HEAD`
echo "home: ${RE_CUR_HOME} -> ${RE_RUN_HOME}"
if [ "${RE_CUR_HOME}" != "${RE_RUN_HOME}" ]; then
    for i in ${RE_RUN_SERVERS}; do
        RE_PID=`pgrep -f "redeclipse-${i}"`
        if [ -n "${RE_PID}" ]; then
            echo "sending HUP to ${i} (${RE_PID})"
            kill -s HUP ${RE_PID}
        fi
    done
fi
popd

for i in ${RE_RUN_SERVERS}; do
    echo "${i}: checking.."
    pushd "${HOME}/redeclipse-${i}"
    RE_CUR_VER=`git rev-parse HEAD`
    git pull
    RE_RUN_VER=`git rev-parse HEAD`
    echo "${i}: ${RE_CUR_VER} -> ${RE_RUN_VER}"
    if [ -n "${RE_RUN_VER}" ] && [ "${RE_CUR_VER}" != "${RE_RUN_VER}" ]; then
        git submodule foreach 'git pull'
        RE_PID=`pgrep -f "redeclipse-${i}"`
        if [ -n "${RE_PID}" ]; then
            echo "${i}: sending TERM to ${RE_PID}"
            kill -s TERM ${RE_PID}
        fi
    fi
    popd
done

echo "-"
