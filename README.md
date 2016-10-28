# Simple-Proxy

A simple way to create a TCP proxy using environment variables.

Simple Proxy uses HAProxy.

[![Docker Repository on Quay](https://quay.io/repository/jcmoraisjr/simple-proxy/status "Docker Repository on Quay")](https://quay.io/repository/jcmoraisjr/simple-proxy)

# Usage

Configure and run the proxy:

	docker run -d -p 1936:1936 -p <PORT>:<PORT> -e PROXY_PORT=<PORT> -e SERVER_LIST=<SERVERS> -e LOG_ENDPOINT=<LOG> quay.io/jcmoraisjr/simple-proxy:latest

Where `<PORT>` is the listening port of the proxy and `<SERVERS>` is a comma-separated list of `IP:PORT`. If more than one `IP:PORT` is used, proxy will load balance the requests. `1936` is the listening port of the status page.

`<LOG>` is an optional `ip:port` udp syslog endpoint. If not specified, Simple Proxy will start a syslogd daemon and write HAProxy logs to the stdout.
