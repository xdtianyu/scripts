
- [1. 服务器备份脚本](#服务器备份脚本)
- [2. online.net ftp 备份脚本](#onlinenet-ftp-备份脚本)

# 服务器备份脚本

指定要备份的文件和目录列表， 使用 `zip` 加密备份文件到指定目录，如 `Dropbox` 同步目录。压缩文件密码为随机密码，会通过 `gmail` 发送到指定邮箱。
 
## 下载
 
```
mkdir /root/bin
cd /root/bin
 
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/backup/backup.sh
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/backup/backup.conf
 
chmod +x backup.sh
```
 
## 依赖
 
需要安装 `zip` 用来压缩文件， `sendemail` 用来发送密码通知邮件。
 
```
apt-get install zip libnet-ssleay-perl libio-socket-ssl-perl sendemail
```
 
## 配置
 
修改 `backup.conf` 文件，主要修改
 
**邮件配置**
 
```
EMAIL="receiver@gmail.com"
SENDER="sender@gmail.com"
SENDER_PASSWD="sender_password"
```
 
注意如果 `sender@gmail.com` 启用了两部验证，则应该使用 [应用专用密码](https://security.google.com/settings/security/apppasswords)
 
**文件列表配置**
 
```
FILES=(
    "/root/.vimrc"
    "/root/.bashrc"
    "/root/.my.cnf"
    "/root/.screenrc"
    "/root/.ssh/config"
)
```
 
**目录列表配置**
 
```
DIRS=(
    "/etc"
    "/root/bin"
    "/root/bashfiles"
    "/var/www"
    "/home/git"
)
```
 
**忽略目录中的文件或文件夹**
 
注意如果备份时要跳过目录中的文件或子目录，可以在目标目录中添加一个 `exclude.lst` 文件，如 `/var/www/exclude.lst` 文件内容参考如下
 
```
*/10meg.test
*/cache/*
/var/www/zips/*
/var/www/downloads/*
/var/www/share/*
/var/www/wordpress/dl/*
/var/www/wordpress/mp3/*
/var/www/wordpress/d/*
/var/www/wordpress/wp-content/languages/*
/var/www/wordpress/wp-content/plugins/*
/var/www/wordpress/wp-content/themes/*
/var/www/wordpress/wp-content/uploads/2011/*
```
 
**备份所有文件**
 
如果某次备份要备份所有的文件，即忽略 `exclude.lst` 文件，可以添加 `all` 参数运行
 
```
/root/bin/backup.sh all
```
 
**备份 mysql 配置**
 
```
BACKUP_MYSQL=true
```
 
如果启用 `mysql` 备份，  则需要添加 `/root/.my.cnf` 文件，内容示例如下
 
```
[mysqldump]
user=root
password=123456
```
 
**备份压缩配置**
 
```
ZIP_COMPRESS=true
```
 
如果不启用压缩，则会以存储模式压缩文件和文件夹。
 
**备份保存路径**
 
```
TARGET_DIR="/root/Dropbox"
```
 
备份完成后会移动到 `TARGET_DIR`， 示例中为 `dropbox` 的默认同步路径，可以将文件同步到 `dropbox` 服务器。安装 `dropbox` 请参考 [https://www.dropbox.com/install-linux](https://www.dropbox.com/install-linux)
 
**日志路径**
 
```
LOG_FILE="/var/log/backup.log"
```
 
会将备份过程中的主要操作输出到日志中。
 
 
## cron 定时任务
 
```
10 */4 * * * bash /root/bin/backup.sh >/dev/null 2>&1
30 02 * * 0 bash /root/bin/backup.sh all >>/dev/null 2>&1
```

# online.net ftp 备份脚本
 
## 下载
 
```
mkdir /root/bin
cd /root/bin
 
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/backup/ftpbackup.sh
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/backup/ftpbackup.list
 
chmod +x ftpbackup.sh
```

## 配置

修改 `/root/bin/ftpbackup.sh` 中的 `SERVER` 为账户下的 `FTP server`，`BACKUP_DIR` 为备份文件临时目录。

修改 `/root/bin/ftpbackup.list` 文件，`files` 为要上传的文件，`dirs` 为要备份的目录。

## 运行

`cron` 定时任务

```
5 1 * * * /root/bin/ftpbackup.sh >> /var/log/ftpbackup.log 2>&1
``` 


