#!/bin/sh
set -e
if [ $# -gt 0 ]; then
  exec "$@"
  exit 0
fi
if [ -z "$SERVER_LIST" ] || [ -z "$PROXY_PORT" ]; then
  echo "SERVER_LIST or PROXY_PORT missing"
  exit 1
fi
cfg=/usr/local/etc/haproxy/haproxy.cfg
LOG_ENDPOINT=${LOG_ENDPOINT:-/dev/log}
sed -i "s#{{PROXY_PORT}}#${PROXY_PORT}#;s#{{LOG_ENDPOINT}}#${LOG_ENDPOINT}#" $cfg 
for server in ${SERVER_LIST//,/ }; do
  echo -e "\tserver $server $server check inter 5s"
done >> $cfg
[ "$LOG_ENDPOINT" = "/dev/log" ] && /sbin/syslogd -n -O - &
/usr/local/sbin/haproxy -db -f $cfg &
p=$!
trap "kill -usr1 $p" TERM
wait $p
