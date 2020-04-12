FROM alpine:3

LABEL maintainer="Oleg Kovalenko <monstrenyatko@gmail.com>"

RUN apk update && apk upgrade && \
    apk add --no-cache curl shadow iptables ip6tables openvpn && \
    rm -rf /root/.cache && mkdir -p /root/.cache && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

COPY run.sh firewall.sh firewall6.sh routing.sh routing6.sh /
RUN chmod +x /run.sh /firewall.sh /firewall6.sh /routing.sh /routing6.sh

HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
    CMD curl -L 'https://api.ipify.org'

WORKDIR /config

ENTRYPOINT ["/run.sh"]
CMD ["vpnc-app", "--config /config/client.ovpn"]
