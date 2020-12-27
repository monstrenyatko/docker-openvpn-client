FROM monstrenyatko/alpine

LABEL maintainer="Oleg Kovalenko <monstrenyatko@gmail.com>"

RUN apk update && \
    apk add iptables ip6tables openvpn && \
    # clean-up
    rm -rf /root/.cache && mkdir -p /root/.cache && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

ENV APP_NAME="vpnc-app" \
    APP_BIN="/usr/sbin/openvpn" \
    APP_USERNAME="root" \
    APP_GROUPNAME="openvpn"

COPY run.sh firewall.sh firewall6.sh routing.sh routing6.sh /app/
RUN chown -R root:root /app
RUN chmod -R 0644 /app
RUN find /app -type d -exec chmod 0755 {} \;
RUN find /app -type f -name '*.sh' -exec chmod 0755 {} \;

HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
    CMD curl -L 'https://api.ipify.org'

WORKDIR /config

ENTRYPOINT ["/app/run.sh"]
CMD ["vpnc-app", "--config", "/config/client.ovpn"]
