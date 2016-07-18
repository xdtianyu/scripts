# ddns 更新脚本

这个脚本适用于 openwrt 和 ddwrt 路由动态更新域名。理论上支持所有可以运行 `shell (/bin/sh)` 脚本的 `linux` 环境。

## openwrt

**1\. 下载脚本**

cloudxns:

```
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/ddns/cloudxns.sh
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/ddns/cloudxns.conf
chmod +x cloudxns.sh
```

dnspod:

```
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/ddns/dnspod.sh
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/ddns/dnspod.conf
chmod +x dnspod.sh
```

**2\. 配置**

cloudxns:

```
API_KEY="YOUR_API_KEY"
SECRET_KEY="YOUR_SECRET_KEY"
DOMAIN="example.com"
HOST="ddns"
LAST_IP_FILE="/tmp/.LAST_IP"
```

dnspod:

```
ACCOUNT="xxxxxx@gmail.com"
PASSWORD="xxxxxxxxxx"
DOMAIN="xxxx.xxx.org"
RECORD_LINE="默认"
```

**3\. 运行测试**

dnspod: `./dnspod.sh dnspod.conf`

cloudxns: `./cloudxns.sh cloudxns.conf`

**4\. 添加到 cron 定时任务**

```
/etc/init.d/cron enable
crontab -e
```

添加如下内容，注意修改路径

cloudxns:

```
*/3 * * * * /root/ddns/cloudxns.sh /root/ddns/cloudxns.conf >> /root/ddns/cloudxns.log
```

dnspod:

```
*/3 * * * * /root/ddns/dnspod.sh /root/ddns/dnspod.conf >> /root/ddns/dnspod.log
```

## ddwrt

**1\. 下载脚本**

下载脚本及配置文件,保存文件到 `/jffs` 及 `/opt` 等不会重启丢失的目录，注意可能需要在网页管理页面先启用 `jffs`

dnspod:

```
curl -k -s https://raw.githubusercontent.com/xdtianyu/scripts/master/ddns/dnspod.sh
curl -k -s https://raw.githubusercontent.com/xdtianyu/scripts/master/ddns/dnspod.conf
chmod +x dnspod.sh
```

cloudxns:

```
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/ddns/cloudxns.sh
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/ddns/cloudxns.conf
chmod +x cloudxns.sh
```


**2\. 修改配置文件**

dnspod:

```
ACCOUNT="xxxxxx@gmail.com"
PASSWORD="xxxxxxxxxx"
DOMAIN="xxxx.xxx.org"
RECORD_LINE="默认"
```

cloudxns:

```
API_KEY="YOUR_API_KEY"
SECRET_KEY="YOUR_SECRET_KEY"
DOMAIN="example.com"
HOST="ddns"
LAST_IP_FILE="/tmp/.LAST_IP"
```

**3\. 运行测试**

dnspod: `./dnspod.sh dnspod.conf`

cloudxns: `./cloudxns.sh cloudxns.conf`

**4\. 添加 cron 定时任务**

ddwrt 在网页管理页面添加 cron 定时任务，注意修改命令的路径:

dnspod:

```
*/3 * * * * root /jffs/ddns/dnspod.sh /jffs/ddns/dnspod.conf >> /jffs/ddns/cloudxns.log
```

cloudxns:

```
*/3 * * * * root /jffs/ddns/cloudxns.sh /jffs/ddns/cloudxns.conf >> /jffs/ddns/cloudxns.log
```

## 更多细节内容可以参考我之前写的博客

[ddwrt路由/linux动态解析ip(ddns)到dnspod配置](https://www.xdty.org/1841)

[用于ddwrt或openwrt的cloudxns动态域名更新shell脚本](https://www.xdty.org/1907)
