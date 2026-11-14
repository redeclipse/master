# Official Server
Trusted moderators, administrators, and developers are given access to this repository to maintain the official server environment. It contains the server scripts and configuration files, including the global lists which contain bans, etc.

## Managing
You can access this repository by doing a checkout. If you don't want to do a git checkout of the repository, you can edit the files using the GitHub visual editor and commit directly to the repository from there. Please try to add a descriptive commit message in order to better communicate with your fellow moderators.

There is currently one server run at the moment, *official*. Servers each have a directory in this repository for their home folder, which contains their respective `servinit.cfg`.

The global trusts, bans and other lists, and the accounts, are no longer kept here. The master server loads and saves them itself, in files on the server that aren't shared: `authuser.cfg` (player accounts), `authserv.cfg` (server accounts) and `servctrl.cfg` (the global lists). Administrators change them while signed in on the website's account page, or through the master's Web API (see `doc/web-api-guide.md` in the base repository). Each save keeps the previous file as `.bak` and a dated copy a day for 14 days.

Secrets the master needs, which must never be committed, go in `official/secrets.cfg` on the server:

```
mastersmtpuser "the Gmail account"
mastersmtppass "its App Password"
masterturnstilesecret "Cloudflare Turnstile's secret key"
masterdiscordclient "the Discord application's client ID"
masterdiscordsecret "its client secret"
```

The Gmail account needs 2-step verification and an App Password, and `contact@redeclipse.net` added as a verified "send mail as" address.

## Bans
Global bans are added and removed from the website's account page by administrators. Global bans should only be used when a player persistently violates the Multiplayer Guidelines and continues to be a nuisance despite temporary bans that get placed. *Global bans are a last resort*. Put the date in the ban's reason. It is encouraged to clear global bans after an acceptable time has passed, depending on the severity of the offence. No ban should exceed three months unless the problem perists.

## Trusts
In order to limit excessive server proliferation, the master server limits the number of connections from a single host. Adding a trust allows a host to have as many concurrent sessions as they want. These should only be added if the hoster is a known/trusted community member and has a very good reason for needing more than the assigned limit.

## Update cycle
The server runs the update sequence every ten minutes (X:00, X:10, X:20 .. X:50), at which point the server will reload the configuration and pass the updated information to all connected servers. The cycle will continue by comparing the current binary hash to that of the current stable build and signal the server to terminate if it has changed.

## Scripts
There's a separate readme in the scripts directory on the voodoo conducted by the scripts which are called by cron.
