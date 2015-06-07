###u2helper###

u2helper 是一个整理transmission下载的脚本

###配置###

重命名 `config.json.example` 为 `config.json`

1. 设置 `download_dir` 为你的 transmission 下载位置，与 `download-dir` 一致
2. 设置 `target_dir_parent` 到你要移动到的位置 , 比如: `/mnt/usb`. 然后这个脚本会根据分类自动生成 `/mnt/usb/动漫`, `/mnt/usb/音乐`, `/mnt/usb/字幕` 目录. 你可以在 `transmission.py` `target_dir` 中修改这些名称.
3. 设置 `transmission_url` 到 transmission web rpc 地址, 如 `https://your.doamin.name/transmission/rpc`
4. 设置 `transmission_user` 和 `transmission_password` 为 transmission 网页管理用户名和密码
5. 设置 `uid` 为你的 u2 uid
6. 设置 `nexusphp_u2` 和 `__cfduid` 为你 u2 cookies. 


###用法###

这个脚本依赖 `BeautifulSoup4` and `requests`, 先确保它们已被安装.

1\. 首先获得所你当前做种的信息

`python u2.py`

这一步会生成一个 `seeding.json` 文件, 它包含你的所有做种信息  `标题`, `类`, `副标题`, `文件夹(或文件名)`, `id`, `名称`. 此文件被 `transmission.py` 调用, 每一个种子的抓取过程限制在3秒. 所以抓取60个种子信息会耗时3分钟.

2\. 设置下载位置

`python transmission.py`

这一步会调用 transmission rpc 设置下载位置接口，会自动将文件移动到 `目标父目录/类别名/资源名`。每一个请求会有1秒延时，所以移动60个种子会耗时1分钟
