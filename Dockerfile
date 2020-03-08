FROM alpine:3

MAINTAINER Oleg Kovalenko <monstrenyatko@gmail.com>

RUN apk update && apk upgrade && \
    apk add --no-cache curl openvpn shadow iptables ip6tables && \
    rm -rf /root/.cache && mkdir -p /root/.cache && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

COPY run.sh firewall.sh firewall6.sh routing.sh routing6.sh /
RUN chmod +x /run.sh /firewall.sh /firewall6.sh /routing.sh /routing6.sh

HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
    CMD curl -L 'https://api.ipify.org'

WORKDIR /config

ENTRYPOINT ["/run.sh"]
CMD ["vpnc-app", "--config /config/client.ovpn"]
