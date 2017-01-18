#!/bin/sh
date -u

echo "updating home.."
pushd "${HOME}/master" 2>&1 >/dev/null
git pull --rebase
popd 2>&1 >/dev/null

echo "updating statsdb.."
pushd "${HOME}/statsdb-interface" 2>&1 >/dev/null
git pull --rebase
popd 2>&1 >/dev/null

echo "running screens.."
screen -S redeclipse -t 0 -A -d -m
screen -S redeclipse -X screen -t 1
# screen -S redeclipse -X screen -t 2

echo "opening official server screen.."
screen -S redeclipse -p 0 -X stuff $'. "${HOME}/master/scripts/runserver.sh" official\n'

echo "opening statistics database screen.."
screen -S redeclipse -p 1 -X stuff $'. "${HOME}/master/scripts/runserver.sh" statsdb\n'

echo "-"
