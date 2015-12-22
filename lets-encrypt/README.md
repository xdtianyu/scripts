A shell script to get/update Let's encrypt certs quickly. [中文](https://github.com/xdtianyu/scripts/blob/master/lets-encrypt/README-CN.md)
------------

This script uses acme_tiny.py to auth, fetch and update cert，no need for other dependency.

**Download**

```
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/lets-encrypt/letsencrypt.conf
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/lets-encrypt/letsencrypt.sh
chmod +x letsencrypt.sh
```

**Configuration**

Only modify DOMAIN_KEY DOMAIN_DIR DOMAINS to yours.

```
ACCOUNT_KEY="letsencrypt-account.key"
DOMAIN_KEY="example.com.key"
DOMAIN_DIR="/var/www/example.com"
DOMAINS="DNS:example.com,DNS:whatever.example.com"
```

key files will be gererated automatically.

**Run**

```
./letsencrypt.sh letsencrypt.conf
```

**Attention**

Domain name need bind to `DOMAIN_DIR` e.g. `/var/www/example.com`，that is to say visit `http://example.com` `http://whatever.example.com` can get into `/var/www/example.com` directory，this is used to verify your domain.

**cron task**

Update the certs every month，you can add your command to the end of script to reload your service, e.g. `service nginx reload`

```
0 0 1 * * /etc/nginx/certs/letsencrypt.sh /etc/nginx/certs/letsencrypt.conf >> /var/log/lets-encrypt.log 2>&1
```
