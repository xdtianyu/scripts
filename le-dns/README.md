通过 DNS 验证方式获取 lets-encrypt 证书的快速脚本
----------------

脚本基于 [letsencrypt.sh](https://github.com/lukas2511/letsencrypt.sh)，通过调用 dns 服务商接口更新 TXT 记录用于认证，实现快速获取 lets-encrypt 证书。无需root权限，无需指定网站目录及DNS解析

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
#ECC=TRUE
```

修改其中的 `API_KEY` 及 `SECRET_KEY` 为您的 [cloudxns api key](https://www.cloudxns.net/AccountManage/apimanage.html) ，修改 `DOMAIN` 为你的根域名，修改 `CERT_DOMAINS` 为您要签的域名列表，需要 `ECC` 证书时请取消 `#ECC=TRUE` 的注释。

**运行**

`./le-cloudxns.sh cloudxns.conf`

最后生成的文件在当前目录的 certs 目录下

**cron 定时任务**

如果证书过期时间不少于30天， [letsencrypt.sh](https://github.com/lukas2511/letsencrypt.sh) 脚本会自动忽略更新，所以至少需要29天运行一次更新。

每隔20天(每个月的2号和22号)自动更新一次证书，可以在 `le-cloudxns.sh` 脚本最后加入 service nginx reload等重新加载服务。

`0 0 2/20 * * /etc/nginx/le-cloudxns.sh /etc/nginx/le-cloudxns.conf >> /var/log/le-cloudxns.log 2>&1`

**注意** `ubuntu 16.04` 不能定义 `day of month` 含有开始天数的 `step values`，可以替换命令中的 `2/20` 为 `2,22`。

更详细的 crontab 参数请参考 [crontab.guru](http://crontab.guru/) 进行自定义

## dnspod

**下载**

```
wget https://github.com/xdtianyu/scripts/raw/master/le-dns/le-dnspod.sh
wget https://github.com/xdtianyu/scripts/raw/master/le-dns/dnspod.conf
chmod +x le-dnspod.sh
```

**配置**

`dnspod.conf` 文件内容

```
TOKEN="YOUR_TOKEN_ID,YOUR_API_TOKEN"
RECORD_LINE="默认"
DOMAIN="example.com"
CERT_DOMAINS="example.com www.example.com im.example.com"
#ECC=TRUE
```

修改其中的 `TOKEN` 为您的 [dnspod api token](https://www.dnspod.cn/console/user/security) ，注意格式为`123456,556cxxxx`。
修改 `DOMAIN` 为你的根域名，修改 `CERT_DOMAINS` 为您要签的域名列表，需要 `ECC` 证书时请取消 `#ECC=TRUE` 的注释。

**运行**

`./le-dnspod.sh dnspod.conf`

最后生成的文件在当前目录的 certs 目录下

**cron 定时任务**

如果证书过期时间不少于30天， [letsencrypt.sh](https://github.com/lukas2511/letsencrypt.sh) 脚本会自动忽略更新，所以至少需要29天运行一次更新。

每隔20天(每个月的5号和25号)自动更新一次证书，可以在 `le-dnspod.sh` 脚本最后加入 service nginx reload等重新加载服务。

`0 0 5/20 * * /etc/nginx/le-dnspod.sh /etc/nginx/le-dnspod.conf >> /var/log/le-dnspod.log 2>&1`

**注意** `ubuntu 16.04` 不能定义 `day of month` 含有开始天数的 `step values`，可以替换命令中的 `5/20` 为 `5,25`。

更详细的 crontab 参数请参考 [crontab.guru](http://crontab.guru/) 进行自定义
