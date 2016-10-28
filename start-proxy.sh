#!/bin/sh
set -e

# If arg does not start with "--", exec and exit
if [ $# -gt 0 ] && [ "${1#--}" = "$1" ]; then
  exec "$@"
  exit 0
fi

while [ $# -gt 0 ]; do
  param=${1%%=*}
  value=${1#*=}
  case "$param" in
    --server-list) SERVER_LIST=$value;;
    --proxy-port) PROXY_PORT=$value;;
    --log-endpoint) LOG_ENDPOINT=$value;;
    *) die "Invalid option: $param";;
  esac
  shift
done

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
