# reMarkable

Customizations for reMarkable and reMarkable 2 Paper Tablet.
Scripts tested and working on version `2.0.x`, `2.1.x`, `2.11.x` and `3.4.x`

## Automatically change your poweroff and suspend screens every 5 minutes

Starting with version `2.11.x` and above (`3.x` included), ReMarkable loads the suspend screen image during the startup only, so it does not hot load from the filesystem anymore: you need to restart the device to see the new randomly selected image.

I will explore the possibility of reloading the interface in memory. I already found how to reload the entire UI, but I will apply this feature only if I can find a way to do it during the device's sleep time rather than when the user is actively using it.

### List of images
After the installation of the script, every image in the following folders is eligible to be randomly selected for the poweroff or the suspended screen, accordingly to the dedicated folder. The name of the files is not relevant.

```bash
/home/root/customization/images/poweroff
/home/root/customization/images/suspended
```

There is a size limit for the images you can use. I don't know the exact size, but with some trials and errors I tested images up to `310` Kb without problems. I was not able to load images bigger than `600` Kb, so I removed them from the repo.

I'm sorry I cannot give credits for the beautiful images included by default in the scripts.  I found them on Facebook but I can't find the author anymore. If you find the author, plase send a PR to this repo.

### Manual installation

- Clone this repo

```bash
git clone git@github.com:Neurone/reMarkable.git reMarkable-customizations
```

- Connect to your reMarkable via SSH (via USB or WiFi, change the IP accordingly) and copy this repo into a temp folder

```bash
scp -r reMarkable-customizations root@10.11.99.1:/home/root/temp-reMarkable-customizations
```

- Login into your reMarkable

```bash
❯ ssh root@10.11.99.1
root@10.11.99.1's password:
ｒｅＭａｒｋａｂｌｅ
╺━┓┏━╸┏━┓┏━┓   ┏━┓╻ ╻┏━╸┏━┓┏━┓
┏━┛┣╸ ┣┳┛┃ ┃   ┗━┓┃ ┃┃╺┓┣━┫┣┳┛
┗━╸┗━╸╹┗╸┗━┛   ┗━┛┗━┛┗━┛╹ ╹╹┗╸
reMarkable: ~/
```

- Create dedicated folders for your scripts and images

```bash
mkdir -p /usr/share/remarkable/scripts
mkdir -p /home/root/customization/images/poweroff
mkdir -p /home/root/customization/images/suspended
```

- Copy the script into the correct folder and set it executable

```bash
cp /home/root/temp-reMarkable-customizations/scripts/random-screens/set-random-screens.sh /usr/share/remarkable/scripts/
chmod +x /usr/share/remarkable/scripts/set-random-screens.sh
```

- Copy some images under dedicated folders

```bash
cp /home/root/temp-reMarkable-customizations/images/poweroff/* /home/root/customization/images/poweroff
cp /home/root/temp-reMarkable-customizations/images/suspended/* /home/root/customization/images/suspended
```

- Copy service and timer in the correct folder

```bash
cp /home/root/temp-reMarkable-customizations/scripts/random-screens/random-screens.service /usr/lib/systemd/user/random-screens.service
cp /home/root/temp-reMarkable-customizations/scripts/random-screens/random-screens.timer /usr/lib/systemd/user/random-screens.timer
```

- Save original images, without overwriting previous original files

```bash
yes n | cp -i /usr/share/remarkable/poweroff.png /usr/share/remarkable/poweroff.original.png
yes n | cp -i /usr/share/remarkable/suspended.png /usr/share/remarkable/suspended.original.png
```

- You can now delete your temp folder

```bash
rm -rf /home/root/temp-reMarkable-customizations
```

- Enable service and timer

```bash
systemctl enable /usr/lib/systemd/user/random-screens.timer
systemctl enable /usr/lib/systemd/user/random-screens.service
```

- Restart your reMarkable (random images are selected)

- Restart again your reMarkable (previously selected random images are loaded)

- You should now see your custom suspend and poweroff image in place

### Installation script

WIP :)

### Change the frequecy of the updates

You can change the frequency of the refresh by modifying the value `OnUnitActiveSec` inside the file `/usr/lib/systemd/user/random-screens.timer` and then restarting your reMarkable.

### Troubleshooting

To do some troubleshooting, you can use the following command to check the active timers. You should see `random-screens.timer` listed there, without error.

```bash
❯ systemctl list-timers --all
NEXT                         LEFT          LAST                         PASSED      UNIT                         ACTIVATES
Tue 2023-06-20 19:44:06 UTC  2min 53s left Tue 2023-06-20 19:39:06 UTC  2min 6s ago random-screens.timer         random-screens.service
Wed 2023-06-21 19:16:32 UTC  23h left      Tue 2023-06-20 19:12:49 UTC  28min ago   systemd-tmpfiles-clean.timer systemd-tmpfiles-clean.service

2 timers listed.
```

You can also check the status of the `random-screens` service. You should see it was activated within the last 5 minutes (or the frequency you customly set) and without errors.

```bash
❯ systemctl status random-screens.service
● random-screens.service - Set random images for splash screens
     Loaded: loaded (/usr/lib/systemd/user/random-screens.service; enabled; vendor preset: disabled)
     Active: inactive (dead) since Tue 2023-06-20 19:43:08 UTC; 38s ago
TriggeredBy: ● random-screens.timer
    Process: 175 ExecStart=/usr/share/remarkable/scripts/set-random-screens.sh (code=exited, status=0/SUCCESS)
   Main PID: 175 (code=exited, status=0/SUCCESS)

Jun 20 19:43:08 reMarkable systemd[1]: Started Set random images for splash screens.
Jun 20 19:43:08 reMarkable systemd[1]: random-screens.service: Succeeded.
```
