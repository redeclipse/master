#!/bin/sh
date
echo "running screens"
screen -S redeclipse -t 0 -A -d -m
screen -S redeclipse -X screen -t 1
screen -S redeclipse -p 0 -X stuff $'. "${HOME}/runserver.sh" master\n'
sleep 60
screen -S redeclipse -p 1 -X stuff $'. "${HOME}/runserver.sh" elara\n'
echo "done."
