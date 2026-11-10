FROM haproxy:alpine@sha256:b9fe316f718d5015c5cfebd8ca019591f3e44656f61d93cb8b59a1028961e530

LABEL maintainer "Leonardo Gatica <lgatica@protonmail.com>"

ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]
CMD haproxy -- /usr/local/etc/haproxy/*.cfg
EXPOSE 80 443
ENV PORT=80 HOST=localhost

RUN apk add --no-cache openssl &&\
    adduser -h /var/lib/haproxy -D haproxy &&\
    chmod go= /var/lib/haproxy

COPY *.cfg /usr/local/etc/haproxy/
COPY *.sh /usr/local/sbin/
VOLUME ["/etc/ssl/private", "/usr/local/etc/haproxy/errors"]
