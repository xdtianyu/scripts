这个脚本可以做一个本地到服务器的下载速度测试，测试完成后会发送邮件到你的邮箱

###openwrt 依赖

这个脚本使用了 `curl` `wget` `timeout` and `https`. 如果你使用的是 openwrt 路由器, 你需要安装以下依赖

```
opkg update
opkg install coreutils-timeout
opkg install ca-certificates
opkg install curl
opkg install wget
```

###如何使用

**1\. 从 github 获取脚本**
```
cd ~/bin
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/speedtest/speedtest.sh -O speedtest
chmod +x speedtest
```
你可以添加 `~/bin` 到你的环境变量，修改 `/etc/profile` 文件的 `PATH`

**2\. 脚本配置**

修改 `EMAIL` 为的邮箱地址.

修改 `TEST_FILES` 数组为你的测试文件地址. 每一个测试会在5秒后强制打断 即 `timeout`.

你可以修改 `NAME` 为 `speedtest(home)` 来区分其他测试.

**3\. 运行测试**

```
~/bin/speedtest
```
运行完成后检查邮查看结果

**4\. 添加到 `crontab`**


```
crontab -e

25 * * * * /root/bin/speedtest
```

之后会在每小时25分运行一次测试，并将测试结果发送到你的邮箱
