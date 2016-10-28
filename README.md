# Simple-Proxy

A simple way to create a TCP proxy with dynamic configuration.

Simple Proxy uses HAProxy.

[![Docker Repository on Quay](https://quay.io/repository/jcmoraisjr/simple-proxy/status "Docker Repository on Quay")](https://quay.io/repository/jcmoraisjr/simple-proxy)

# Usage

Configure and run the proxy:

	docker run -d -p 1936:1936 -p <PORT>:<PORT> quay.io/jcmoraisjr/simple-proxy:latest --proxy-port=<PORT> --server-list=<SERVERS> --log-endpoint=<LOG>

See options below.

# Options

* `--proxy-port` is the listening port of the proxy.
* `--server-list` is a comma-separated list of `IP:PORT`. If more than one `IP:PORT` is used, proxy will load balance the requests.
* `--log-endpoint` is an optional `ip:port` udp syslog endpoint. If not specified, Simple Proxy will start a syslogd daemon and write HAProxy logs to stdout.

Simple Proxy uses `1936` as the listening port of the status page.

# Deploy

The following unit deploys Simple Proxy as a systemd unit.

Change `<PORT>` and `<SERVERS>` to the listening port and list of servers.

Change `<LOG>` to the `IP:PORT` of the external syslog daemon or remove the option `--log-endpoint`.

	[Unit]
	Description=Simple Proxy
	After=docker.service
	Requires=docker.service
	[Service]
	ExecStartPre=-/usr/bin/docker stop simple-proxy
	ExecStartPre=-/usr/bin/docker rm simple-proxy
	ExecStart=/usr/bin/docker run \
	  -p 1936:1936 \
	  -p <PORT>:<PORT> \
	  quay.io/jcmoraisjr/simple-proxy:latest \
		--log-endpoint=<LOG> \
		--proxy-port=<PORT> \
		--server-list=<SERVERS>
	RestartSec=10s
	Restart=always
	[Install]
	WantedBy=multi-user.target
