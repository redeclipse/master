#!/bin/sh
date
echo "updating home"
pushd "${HOME}/redeclipse-master/home" 2>&1 >/dev/null
git pull && killall -HUP redeclipse_server_linux && killall -HUP redeclipse_elara_linux
popd 2>&1 >/dev/null

RE_CURVER=`cat "${HOME}/redeclipse-master/bin/version.txt"`
RE_RUNVER=`cat /webspace/redeclipse.net/files/stable/bins.txt`

RE_INT="false"
echo "checking master server.."
curl --fail --max-time 3 http://play.redeclipse.net:28800/version || (RE_INT="true"; killall -INT redeclipse_server_linux)

echo "update (have: ${RE_CURVER} want: ${RE_RUNVER})"
if [ -n "${RE_RUNVER}" ] && [ "${RE_CURVER}" != "${RE_RUNVER}" ]; then
  if [ "${RE_INT}" = "true" ]; then
    echo "restarting master.."
    killall -TERM redeclipse_server_linux &
  fi
  while [ "${RE_CURVER}" != "${RE_RUNVER}" ]; do
    sleep 10
    RE_CURVER=`cat "${HOME}/redeclipse-master/bin/version.txt"`
  done
  echo "restarting elara.."
  killall -TERM redeclipse_elara_linux &
fi
echo "done."
