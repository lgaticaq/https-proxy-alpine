FROM haproxy:alpine@sha256:bb56b88133c0f42db88a4fab51ad21b1a5ea1596cd6c195a7b4c02bacbcb60c0

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
