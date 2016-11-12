# online.net ftp 备份脚本


## 配置

修改 `/root/bin/ftpbackup.sh` 中的 `SERVER` 为账户下的 `FTP server`，`BACKUP_DIR` 为备份文件临时目录。

修改 `/root/bin/ftpbackup.list` 文件，`files` 为要上传的文件，`dirs` 为要备份的目录。

## 运行

`cron` 定时任务

```
5 1 * * * /root/bin/ftpbackup.sh >> /var/log/ftpbackup.log 2>&1
``` 


