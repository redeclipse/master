#!/bin/sh
date -u

echo "updating repo.."
pushd "${HOME}/master"
git pull --rebase
popd

echo "running screens.."
screen -S redeclipse -t 0 -A -d -m
screen -S redeclipse -X screen -t 1

RE_CURVER=`cat "${HOME}/redeclipse-master/bin/version.txt"`
RE_RUNVER=`cat /webspace/redeclipse.net/files/stable/bins.txt`

echo "opening master screen.."
screen -S redeclipse -p 0 -X stuff $'. "${HOME}/master/scripts/runserver.sh" master\n'

echo "waiting for update.."
while [ "${RE_CURVER}" != "${RE_RUNVER}" ]; do
  sleep 10
  RE_CURVER=`cat "${HOME}/redeclipse-master/bin/version.txt"`
done

echo "opening elara screen.."
screen -S redeclipse -p 1 -X stuff $'. "${HOME}/master/scripts/runserver.sh" elara\n'

echo "done."
