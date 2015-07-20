This script can do a speedtest to servers and then send the result to your email, you can add this to crontab.

###openwrt dependency

This script are using `curl` `wget` `timeout` and `https`. If you're using this on openwrt router, you need to do the following commands

```
opkg update
opkg install coreutils-timeout
opkg install ca-certificates
opkg install curl
opkg install wget
```

###How to use

**1\. Get the script from github**
```
cd ~/bin
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/speedtest/speedtest.sh -O speedtest
chmod +x speedtest
```
You can add `~/bin` to your `PATH` in `/etc/profile`

**2\. Script configuration**

Replace `EMAIL` with your email address.

Replace `TEST_FILES` arrays with your own test files. Each test will only has 5 seconds and then `timeout`.

You can replace `NAME` with `speedtest(home)` to distinguish other tests.

**3\. Do a speedtest**

```
~/bin/speedtest
```
Then check your email for result.

**4\. Add to `crontab`**


```
crontab -e

25 * * * * /root/bin/speedtest
```

This means at every hour's 25, a speedtest runs and you get a result email. 
