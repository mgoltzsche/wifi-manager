FROM debian:10-slim
RUN apt-get update && apt-get install -y locales curl dnsmasq wireless-tools && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ARG VERSION="4.4.0"
RUN set -eux; \
	ARCH=`uname -m | sed 's/x86_64/amd64/'`; \
	mkdir /tmp/wifi-connect; \
	curl -fsSL "https://github.com/balena-io/wifi-connect/releases/download/v$VERSION/wifi-connect-v$VERSION-linux-$ARCH.tar.gz" \
		| tar -xvz -C  /tmp/wifi-connect; \
	mv /tmp/wifi-connect/wifi-connect /usr/local/bin/; \
	mkdir -p /usr/local/lib/wifi-connect; \
	mv /tmp/wifi-connect/ui /usr/local/lib/wifi-connect/web
ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket \
    UI_DIRECTORY=/usr/local/lib/wifi-connect/web \
    LANG=en_US.utf8
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

# to run: sudo podman run -ti --rm -v /:/host --network host --cap-add NET_ADMIN localhost/mgoltzsche/wifi-connect:dev
