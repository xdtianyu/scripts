## General

autobuild.sh will generate a file 'opensips.run' and send emails to the receivers. Add cron will auto build at every day's 0:00. This script also push the release file to remote server. Then you can call ./opensips.run on remote server to install opensips. 

## Useage

1. First, you need a user maybe named builder or any else to build opensips, and sudo permission too.
2. Add this script to PATH, maybe ~/bin. Make sure the *.sh files have execute access.
3. Add a cron tab with something like this 
'0 0 * * * /home/builder/bin/autobuild.sh > /dev/null 2>&1 &'
4. You need to modify script's location if necessary, for example my file tree is:
.
```bash
├── bin
│   ├── autobuild.sh
│   ├── mail.cfg
│   └── make.sh
└── opensips
    └── install
        ├── build.sh
        ├── makeself-header.sh
        └── makeself.sh
```
5. You need modify email.conf for the receivers.
6. You need to modify the push server where scp pushs the file 'opensips.run'. Maybe need setup auth key of remote server.

## Related files
autobuild.sh, mail.cfg, make.sh, build.sh, autobuild.cron

##More information please read *.sh files.

