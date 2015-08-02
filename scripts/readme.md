# Server Operation Basics

## Connecting to the server
You should be mostly familiar with **ssh** and how to generate a public/private key combination. (add more info on generating SSH and how to add it to authorized keys)

## Maintaining the server
The server is set up to mostly maintain itself. It does this with the use of **cron**.

The crontab basically looks like this:
```
# m h  dom mon dow   command
@reboot (/bin/sh --login "${HOME}/master/scripts/runscreen.sh" 2>&1 | tee --append "${HOME}/logs/screen.log" &)
0,10,20,30,40,50 * * * * (/bin/sh --login "${HOME}/master/scripts/runupdate.sh" 2>&1 | tee --append "${HOME}/logs/update.log" &)
0,30 * * * * (/bin/sh --login "${HOME}/master/scripts/runrotate.sh" 2>&1 | tee --append "${HOME}/logs/rotate.log" &)
# For more information see the manual pages of crontab(5) and cron(8)
```

Comments start with `#`, other lines tell cron what to do and when:
* The first command `@reboot` tells it to execute `runscreen.sh` when the system first starts, and to pipe output to `logs/screen.log`
* The second command `0,10,20,30,40,50 * * * *` tells it to execute `runupdate.sh` every 10 minutes, and to pipe output to `logs/update.log`
* The third command `0,30 * * * *` tells it to execute `runrotate.sh` every 30 minutes, and to pipe output to `logs/rotate.log`

# Script Files

## runscreen.sh
This file is responsible for starting the initial screen session, and loading the servers as windows inside that session.

There are two main windows opened by this file:
* `runserver.sh master` starts the master server; and
* `runserver.sh stable` starts the stable server

Physical access to these sessions is obtained by typing `screen -r` when logged in via ssh. While using screen press `CTRL+A` then `0` for window zero (0), or `1` for window one (1). Press `CTRL+C` in a window to interrupt the server, it will automatically restart.

## runserver.sh
This file is responsible for starting each server, and maintaining it in an infinite loop (`while [ 0 != 1]`) so that it can be interrupted and automatically restarted (automatic updates, unexpected crashes, etc). This is the script running in each of the two screen windows.

Should you accidentally break out of the infinite loop, you can press `UP` to bring up the last command and press `ENTER` to re-execute it. Failing that, use this command in each window:
* Window 0: `. "${HOME}/master/runserver.sh" master`
* Window 1: `. "${HOME}/master/runserver.sh" stable`

## runupdate.sh
This file is responsible for updating this repository on the server and telling the servers to reload their configuration, then updates the web space (for [http://redeclipse.net](http://redeclipse.net)). It also checks if the master server is responding, and kills (`SIGKILL`) if it doesn't. The script then goes on to check if there is a binary update to perform, then signals to terminate when the server is next empty (`SIGTERM`).
