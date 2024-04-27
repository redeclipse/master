#!/bin/sh
date -u

echo "updating home.."
cd "${HOME}/master"
git pull

cd "${HOME}"

echo "running screens.."
screen -S redeclipse -t 0 -A -d -m

echo "opening official server screen.."
screen -S redeclipse -p 0 -X stuff '/bin/sh -l "${HOME}/master/scripts/runserver.sh" official\n'

echo "-"
