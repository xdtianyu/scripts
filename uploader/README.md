# Uploader

上传文件到七牛和腾讯云存储

## 配置

参考 `config.py.example` 文件，修改 `API key`，修改 `targets` 为要上传的文件或目录

## 运行

```shell
virtualenv -p python3 venv
source venv/bin/activate
pip install -r requirements.txt -I
python upload.py
```

**crontab**

```shell
10 * * * * /path/to/uploader/cron.sh >> /var/log/uploader.log 2>&1
```

