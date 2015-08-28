This script will download `*.zip` and `*.img` files from [http://download.cyanogenmod.org/](http://download.cyanogenmod.org/) and then upload it to baiduyun.

## Dependency

This tool requires `python3` `bypy` `python3-bs4`, `trickle` is used for limiting upload speed.

```
apt-get install python3 python3-bs4 trickle
git clone https://github.com/houtianze/bypy
```

## Usage

Make sure the paths is `/root/bypy/bypy.py` `/root/cm/cm.py`, otherwise you have to modify the script for your need.

**Upload**
```
cd ~/cm/
chmod +x cm.sh cm.py
screen
./cm.py
```

This will fetch `http://download.cyanogenmod.org/` and download `*.zip` `*.img` and check their `sha1`. Then upload it to baiduyun.

The default download directory is `/var/cyanogenmod`, and the default upload directory is `/YOUR_APP_DIR/cm/DEVICE`. Log file is saved in `/var/cyanogenmod/DEVICE/log/DEVICE.log`. Files have been uploaded is recorded in `/root/cm/cm.json`, file exists in `cm.json` will not download again. The script checks only the last 50 builds. After all uploads are done, it will sleep 60s and then check again.

**Generate device list**

```
./cm.py --list
```
