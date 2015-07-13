#!/bin/sh
date -u
echo "updating home.."
pushd "${HOME}/master" 2>&1 >/dev/null
git pull --rebase
killall -HUP redeclipse_server_linux
killall -HUP redeclipse_elara_linux
popd 2>&1 >/dev/null

echo "updating web.."
pushd "/webspace/redeclipse.net"
git pull --rebase
popd

RE_CURVER=`cat "${HOME}/redeclipse-master/bin/version.txt"`
RE_RUNVER=`cat "/webspace/redeclipse.net/files/stable/bins.txt"`
RE_DOKILL="false"

echo "checking master server.."
curl --fail --max-time 3 http://play.redeclipse.net:28800/version || (RE_DOKILL="true"; killall -KILL redeclipse_server_linux)

if [ ! -e "${HOME}/.runupdate" ]; then
  echo "checking update: ${RE_CURVER} -> ${RE_RUNVER})"
  if [ -n "${RE_RUNVER}" ] && [ "${RE_CURVER}" != "${RE_RUNVER}" ]; then
    date -u > "${HOME}/.runupdate"
    if [ "${RE_DOKILL}" != "true" ]; then
      echo "restarting master.."
      killall -TERM redeclipse_server_linux
    fi
    echo "waiting for update.."
    while [ "${RE_CURVER}" != "${RE_RUNVER}" ]; do
      sleep 10
      RE_CURVER=`cat "${HOME}/redeclipse-master/bin/version.txt"`
    done
    echo "restarting elara.."
    killall -TERM redeclipse_elara_linux
    rm -f "${HOME}/.runupdate"
  fi
else
  echo "waiting for previous update.."
fi
echo "done."
