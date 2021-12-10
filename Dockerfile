FROM alpine:3.14 AS build
#RUN apk add --update --no-cache git make gcc g++ pkgconf musl-dev glib-dev hostapd libqrencode-dev libpng-dev
RUN apk add --update --no-cache git
ARG LWH_VERSION=v4.3.3
RUN git clone --branch=$LWH_VERSION --depth=1 https://github.com/lakinduakash/linux-wifi-hotspot /linux-wifi-hotspot

# nodogsplash doesn't work yet:
FROM alpine:3.14 AS nodogsplash
RUN apk add --update --no-cache git make gcc g++ musl-dev linux-headers libmicrohttpd-dev libmicrohttpd-static
ARG NODOGSPLASH_VERSION=v5.0.0
RUN git clone --branch=$NODOGSPLASH_VERSION --depth=1 https://github.com/nodogsplash/nodogsplash.git /nodogsplash
WORKDIR /nodogsplash
#RUN rm /usr/lib/libmicrohttpd.so*
#RUN make LDFLAGS='-s -w -static'
RUN make

FROM alpine:3.14 AS ap
RUN apk add --update --no-cache bash hostapd dhcp iptables iw wireless-tools dnsmasq libmicrohttpd
COPY --from=build /linux-wifi-hotspot/src/scripts/create_ap /usr/local/bin/create_ap
COPY --from=build /linux-wifi-hotspot/src/scripts/create_ap.conf /etc/create_ap.conf
COPY --from=nodogsplash /nodogsplash/ndsctl /usr/local/bin/ndsctl
COPY --from=nodogsplash /nodogsplash/nodogsplash /usr/local/bin/nodogsplash
COPY --from=nodogsplash /nodogsplash/resources /usr/local/share/nodogsplash/resources
RUN mkdir /etc/nodogsplash && mv /usr/local/share/nodogsplash/resources/nodogsplash.conf /etc/nodogsplash/nodogsplash.conf
COPY entrypoint.sh /
CMD ["/entrypoint.sh"]

# start; sudo podman run -ti --rm --network=host --privileged -e AP_SSID=anotherap -e AP_PASSPHRASE=pw123456 --entrypoint sh localhost/mgoltzsche/wifi-manager:dev
