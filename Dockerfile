FROM haproxy:alpine@sha256:2d8b8b8885c4f4b27e7c751f0fa91b1dca47eedccf7bc7ab178c85595431ef5d

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
