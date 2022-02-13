# reMarkable

Customizations for reMarkable and reMarkable 2 Paper Tablet.
Script tested without problem on version `2.0.x`, `2.1.x` and `2.11.x`

With `2.11.x` image files are read only during startup, they are not hot loaded from the filesystem anymore, so to actually see the next image you need to restart the reMarkable. This means that even suspend image cannot be changed on the fly anymore, but you need to restart to see the new suspend image. I will explore the possibility to reload the interface in memory, but only if I can find a way to do it during sleep time and not when the user is actively using the device.

## Automatically change your poweroff and suspend screens every 5 minutes

### Manual installation

- Connect to your reMarkable via ssh and copy this repo into a temp folder i.e. `/home/root/temp/reMarkable-1.0.1`

- From the temp folder, create dedicated folders for your scripts and images

```bash
cd /home/root/temp/reMarkable-1.0.1
mkdir -p /usr/share/remarkable/scripts
mkdir -p /home/root/customization/images/poweroff
mkdir -p /home/root/customization/images/suspended
```

- Copy the script into the correct folder and set it executable

```bash
cp scripts/random-screens/set-random-screens.sh /usr/share/remarkable/scripts/
chmod +x /usr/share/remarkable/scripts/set-random-screens.sh
```

- Copy some images under dedicated folders

```bash
cp images/poweroff/* /home/root/customization/images/poweroff
cp images/suspended/* /home/root/customization/images/suspended
```

Name of the files is not important: every image in the folder will be elegible to be selected randomly by the script. You can find very good example in this repo.
_Note: I found them on Facebook but I can't remember the author anymore, I'm sorry. If you find him/her please PR this repo._

- Copy service and timer in the correct folder

```bash
cp scripts/random-screens/random-screens.service /usr/lib/systemd/user/random-screens.service
cp scripts/random-screens/random-screens.timer /usr/lib/systemd/user/random-screens.timer
```

- Save original images

```bash
cp /usr/share/remarkable/poweroff.png /usr/share/remarkable/poweroff.original.png
cp /usr/share/remarkable/suspended.png /usr/share/remarkable/suspended.original.png
```

You can now delete your temp folder.

- Enable service and timer

```bash
systemctl enable /usr/lib/systemd/user/random-screens.timer
systemctl enable /usr/lib/systemd/user/random-screens.service
```

- Restart your reMarkable

- You should now see one of your custom suspend and poweroff image in place. To do some troubleshooting, you can use these commands:

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

### Installation script

WIP :)

## Changing the timer

You can change the frequency of the refresh modifying the value `OnUnitActiveSec` inside the file `/usr/lib/systemd/user/random-screens.timer` and then restarting your reMarkable.
