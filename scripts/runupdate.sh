#!/bin/sh
date -u
echo "updating home.."
pushd "${HOME}/master" 2>&1 >/dev/null
git pull --rebase
popd 2>&1 >/dev/null

echo "updating web.."
pushd "/webspace/redeclipse.net"
git pull --rebase
popd

echo "checking master server.."
RE_DOKILL="false"
curl --progress-bar --fail --max-time 10 http://play.redeclipse.net:28800/version || (RE_DOKILL="true"; killall -KILL redeclipse_server_linux)

if [ "${RE_DOKILL}" != "true" ]; then
  for i in master stable; do
    RE_CURVER=`cat "${HOME}/redeclipse-${i}/bin/version.txt"`
    RE_RUNVER=`cat "/webspace/redeclipse.net/files/${i}/bins.txt"`
    echo "checking ${i}: ${RE_CURVER} -> ${RE_RUNVER}"
    RE_SIGNAL=-HUP
    RE_PID=`ps ax | grep "redeclipse-${i}" | grep -v "grep redeclipse-${i}" | sed -e 's/^[ \t]*//g;s/[ \t].*$//'`
    if [ -n "${RE_RUNVER}" ] && [ "${RE_CURVER}" != "${RE_RUNVER}" ]; then
      RE_SIGNAL=TERM
    fi
    kill -${RE_SIGNAL} ${RE_PID}
  done
fi
echo "done."
