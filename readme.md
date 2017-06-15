# Official Server
Trusted moderators, administrators, and developers are given access to this repository to maintain the official server environment. It contains the server scripts and configuration files, including the global lists which contain bans, etc.

## Managing
You can access this repository by doing a checkout. If you don't want to do a git checkout of the repository, you can edit the files using the GitHub visual editor and commit directly to the repository from there. Please try to add a descriptive commit message in order to better communicate with your fellow moderators.

There is currently one server run at the moment, *official*. Servers each have a directory in this repository for their home folder, which contains their respective `servinit.cfg`. In general, you shouldn't need to change anything other than `official/iplist.cfg`, which contains the global trusts, bans, etc lists.

## Bans
Global bans should only be used when a player persistently violations the Multiplayer Guidelines and continues to be a nuisance despite temporary bans that get placed. *Global bans are a last resort*. At the end of bans, there are comments showing the date the ban was added; you should maintain this for your own bans too. It is encouraged to clear global bans after an acceptable time has passed, depending on the severity of the offence. No ban should exceed three months unless the problem perists.

## Trusts
In order to limit excessive server proliferation, the master server limits the number of connections from a single host. Adding a trust allows a host to have as many concurrent sessions as they want. These should only be added if the hoster is a known/trusted community member and has a very good reason for needing more than the assigned limit.

## Update cycle
The server runs the update sequence every ten minutes (X:00, X:10, X:20 .. X:50), at which point the server will reload the configuration and pass the updated information to all connected servers. The cycle will continue by comparing the current binary hash to that of the current stable build and signal the server to terminate if it has changed.

## Scripts
There's a separate readme in the scripts directory on the voodoo conducted by the scripts which are called by cron.
