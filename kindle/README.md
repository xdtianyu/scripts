# Kindle

## 配置

参考 `config.py.example` ，修改 `config.py` 文件，填写 `API key`， 请在 [Amazon](https://console.aws.amazon.com/iam/home#security_credential
) 获取。 

```shell
AWS_ACCESS_KEY_ID = "xxx"
AWS_SECRET_ACCESS_KEY = "xxx"
AWS_ASSOCIATE_TAG = "xxx"
```

## 运行

```shell
virtualenv -p python3 venv
source venv/bin/activate
pip install -r requirements.txt -I
python kindle.py
```

**crontab**

```shell
5 0 * * * /path/to/kindle/cron.sh >> /var/log/kindle.log 2>&1
```
