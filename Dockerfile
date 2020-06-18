FROM haproxy:alpine@sha256:771fe9026fcbd166810831fe21fb4234906112ce7383a23c2aa02e2282ea8eb1

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
