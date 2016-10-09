FROM haproxy:1.6-alpine
COPY haproxy.cfg /usr/local/etc/haproxy/
COPY start-proxy.sh /
ENTRYPOINT ["/start-proxy.sh"]
