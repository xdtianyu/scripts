###DownloadHelper###

This can convert nginx auto index page to download links for aria2c, can add mirrors(nginx proxy) to the link too.


```
files servered by nginx (https with basic auth) => mirrors (nginx proxy) =>
index2list.py(copy generated links) => webui-aria2(local aria2c) => HDD/SSD
```

python requests SNI support:

```
pip install pyOpenSSL
pip install ndg-httpsclient
pip install pyasn1
```

