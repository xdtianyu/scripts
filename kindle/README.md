# Kindle

## 运行

```
virtualenv -p python3 venv
source venv/bin/activate
pip install -r requirements.txt -I
python kindle.py
```

**crontab**

```
5 0 * * * /path/to/kindle/cron.sh >> /var/log/kindle.log 2>&1
```
