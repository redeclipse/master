#!/bin/sh
date -u

echo "updating repo.."
pushd "${HOME}/master"
git pull --rebase
popd

echo "running screens.."
screen -S redeclipse -t 0 -A -d -m
screen -S redeclipse -X screen -t 1

echo "opening master screen.."
screen -S redeclipse -p 0 -X stuff $'. "${HOME}/master/scripts/runserver.sh" master\n'

echo "opening stable screen.."
screen -S redeclipse -p 1 -X stuff $'. "${HOME}/master/scripts/runserver.sh" stable\n'

echo "done."
