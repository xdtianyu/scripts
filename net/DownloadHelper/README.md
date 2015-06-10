###DownloadHelper###

This can convert nginx auto index page to download links for aria2c, can add mirrors(nginx proxy) to the link too.


```
files servered by nginx (https with basic auth) => mirrors (nginx proxy) =>
index2list.py(copy generated links) => webui-aria2(local aria2c) => HDD/SSD
```

**python requests SNI support:**

```
pip install pyOpenSSL
pip install ndg-httpsclient
pip install pyasn1
```

**nginx proxy config exmaple**

I suggest you set `proxy_buffering` `off`, otherwise mirrors will use huge bandwidth to cache files.

```
location /downloads/ {
    proxy_buffering off;
    proxy_pass https://www.xxx.com/downloads/;
}
```
