# reMarkable
Customizations for reMarkable Paper Tablet.  
Script tested on version 2.0.x and 2.1.x  
## Automatically change your poweroff and suspend screens every 5 minutes
1. Connect to your reMarkable via ssh and copy this repo your home folder, i.e. I put all artifacts under `/home/root/customization`
2. Create dedicated folders for your scripts and images
```bash
$ mkdir -p /usr/share/remarkable/scripts
$ mkdir -p /home/root/customization/images/poweroff
$ mkdir -p /home/root/customization/images/poweroff
```
3. Copy the script under right position
```bash
$ cp set-random-screens.sh /usr/share/remarkable/scripts/
```
4. Copy some images under dedicated folders
```bash
$ cp ../../images/poweroff/* /home/root/customization/images/poweroff
$ cp ../../images/suspended/* /home/root/customization/images/suspended
```
Name of the files is not important: every image in the folder will be elegible to be selected randomly by the script. You can find very good example in this repo. I found them on Facebook but I can't remember the author anymore, I'm sorry. If you find him/her please PR this repo.
5. Copy service and timer
```bash
cp random-screens.service /usr/lib/systemd/user/random-screens.service
cp random-screens.timer /usr/lib/systemd/user/random-screens.timer
```
4) Enable service and timer
```bash
$ systemctl enable /usr/lib/systemd/user/random-screens.timer
$ systemctl enable /usr/lib/systemd/user/random-screens.service
```
5) Restart your reMarkable
6) You should now see one of your custom suspend and poweroff image in place. To do some troubleshooting, you can use these commands:
```bash
$ systemctl list-timers
NEXT                         LEFT          LAST                         PASSED  UNIT                         ACTIVATES
Mon 2020-04-20 10:07:35 UTC  4min 33s left Mon 2020-04-20 10:02:34 UTC  26s ago random-screens.timer         random-screens.service
Mon 2020-04-20 10:16:34 UTC  13min left    n/a                          n/a     systemd-tmpfiles-clean.timer systemd-tmpfiles-clean.service

$ systemctl status random-screens.service
● random-screens.service - Set random images for splash screens
   Loaded: loaded (/usr/lib/systemd/user/random-screens.service; enabled; vendor preset: enabled)
   Active: inactive (dead) since Mon 2020-04-20 10:02:35 UTC; 2min 21s ago
  Process: 332 ExecStart=/usr/share/remarkable/scripts/set-random-screens.sh (code=exited, status=0/SUCCESS)
 Main PID: 332 (code=exited, status=0/SUCCESS)

Apr 20 10:02:35 remarkable systemd[1]: Started Set random images for splash screens.
```
