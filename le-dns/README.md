通过 DNS 验证方式获取 lets-encrypt 证书的快速脚本
----------------

脚本基于 [letsencrypt.sh](https://github.com/lukas2511/letsencrypt.sh)，通过调用 cloudxns API 实现快速获取 lets-encrypt 证书。无需root权限，无需指定网站目录及DNS解析

## cloudxns

**下载**

```
wget https://github.com/xdtianyu/scripts/raw/master/le-dns/le-cloudxns.sh
wget https://github.com/xdtianyu/scripts/raw/master/le-dns/cloudxns.conf
chmod +x le-cloudxns.sh
```

**配置**

`cloudxns.conf` 文件内容

```
API_KEY="YOUR_API_KEY"
SECRET_KEY="YOUR_SECRET_KEY"
DOMAIN="example.com"
CERT_DOMAINS="example.com www.example.com im.example.com"
```

修改其中的 `API_KEY` 及 `SECRET_KEY` 为您的 [cloudxns api key](https://www.cloudxns.net/AccountManage/apimanage.html) ，修改 `DOMAIN` 为你的根域名，
修改 `CERT_DOMAINS` 为您要签的域名列表

**运行**

```
./le-cloundxns.sh cloudxns.conf
```

最后生成的文件在当前目录的 certs 目录下
