##示例

1\. 修改 `index.php`, 替换 `$api_key = "YOUR_DB_IP_KEY(https://db-ip.com/api/)";` 为你的 api key.

2\. `GET` 请求 如 `curl http://YOUR_DOMAIN_NAME` 会返回你的公网ip地址.

3\. `POST` 请求 如 `curl http://YOUR_DOMAIN_NAME -X POST -d "geo=IP_ADDRESS_YOU_ARE_QUERY"` 会返回 ip 地理信息.
位于中国的ip会使用 `17monip`, 否则使用 `DB-IP API`.
