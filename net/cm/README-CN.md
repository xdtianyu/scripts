这个脚本会从 [http://download.cyanogenmod.org/](http://download.cyanogenmod.org/) 抓取 `*.zip` 及 `*.img` 文件并上传到百度云。

## 依赖

这工具需要 `python3` `bypy` `python3-bs4`, `trickle` 被用来限制上传速度

```
apt-get install python3 python3-bs4 trickle
git clone https://github.com/houtianze/bypy
```

## 使用

请确保路径如下 `/root/bypy/bypy.py` `/root/cm/cm.py`, 否你需要自己修改脚本中的路径

**上传**
```
cd ~/cm/
chmod +x cm.sh cm.py
screen
./cm.py
```

这个命令会抓取 `http://download.cyanogenmod.org/` 下载 `*.zip` `*.img` 文件并检查 `sha1`. 然后上传文件到百度云。

默认的下载文件夹是 `/var/cyanogenmod`, 默认的上传文件夹是 `/YOUR_APP_DIR/cm/DEVICE`. 日志文件保存在 `/var/cyanogenmod/DEVICE/log/DEVICE.log`. 已上传的文件列表保存在 `/root/cm/cm.json`, `cm.json` 中存在的文件将不会再下载. 这个脚本只检查最新的50个编译版本， 当所有上传完成后, 将等待60秒 然后再重新检查.

**生成设备列表**

```
./cm.py --list
```
