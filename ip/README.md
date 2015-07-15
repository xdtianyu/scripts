##Useage

1\. In `index.php`, replace `$api_key = "YOUR_DB_IP_KEY(https://db-ip.com/api/)";` with your api key.

2\. `GET` request e.g. `curl http://YOUR_DOMAIN_NAME` will return your current public ip address.

3\. `POST` request e.g. `curl http://YOUR_DOMAIN_NAME -X POST -d "geo=IP_ADDRESS_YOU_ARE_QUERY"` will return ip geo info.
IP address located in china will use `17monip`, otherwise will use `DB-IP API`.
