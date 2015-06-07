###u2helper###

u2helper is a script for arranging torrents downloaded by transmission. 

###config###

rename `config.json.example` to `config.json`

1. set `download_dir` to your transmission `download-dir`
2. set `target_dir_parent` to the directory which you want move the files in, for example: `/mnt/usb`. Then the script will generate `/mnt/usb/动漫`, `/mnt/usb/音乐`, `/mnt/usb/字幕` forders for different catalog. You can modify the names in `transmission.py` `target_dir` by yourself.
3. set `transmission_url` to your transmission web rpc url, e.g. `https://your.doamin.name/transmission/rpc`
4. set `transmission_user` and `transmission_password` to your transmission web rpc username and password
5. set `uid` to your u2 uid
6. set `nexusphp_u2` and `__cfduid` the same as your u2 cookies. 


###usage###

This script requires `BeautifulSoup4` and `requests`, make sure your have install them first.

1\. First get the torrent info you are seeding

`python u2.py`

This will generate a file named `seeding.json`, it contains an array of your torrents's `title`, `catalog`, `description`, `folder(or filename)`, `id`, `name`. It's used by `transmission.py`, and each torrent fetch shall be limited in 3 seconds. So it will take 3 minutes to get 60 torrents's info.

2\. Set the location of your files

`python transmission.py`

This will call transmission's rpc set location method, it will move the files to `target_dir_parent/catalog/name`. Each request has a delay for 1 second, so it will take 1 minutes to set all 60 torrents.
