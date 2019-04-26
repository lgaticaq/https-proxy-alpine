FROM haproxy:alpine@sha256:4169ba72e100c113ee5d04739235d57af0ace316f6838515cc41d1e9874556c4

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
