# HTTPS Proxy

[![dockeri.co](http://dockeri.co/image/lgatica/https-proxy-alpine)](https://hub.docker.com/r/lgatica/https-proxy-alpine/)

[![Build Status](https://travis-ci.org/lgaticaq/https-proxy-alpine.svg?branch=master)](https://travis-ci.org/lgaticaq/https-proxy-alpine)

Fork from [yajo/docker-https-proxy](https://bitbucket.org/yajo/docker-https-proxy)

Use HAProxy to create a HTTPS proxy.

To understand settings in configuration files, see
[online manual](https://cbonte.github.io/haproxy-dconv/).

## Disclaimer about load balancing

This container uses HAProxy, but **it does not perform load balancing**.
It's just for adding an HTTPS layer to any HTTP container.

However, feel free to fork or subclass this image to do it, or just use other
container for load balancing and link it to this one to add HTTPS to it.

## Usage

Replace PORT and HOST with your port and ip:

```bash
docker run -d -p 80:80 -e PORT=8000 -e HOST=192.168.1.2 -p 443:443 lgatica/https-proxy-alpine
```

Then navigate to `https://localhost` and add security exception.

### When you have a real certificate

You can supply them with environment variables:

```bash
openssl req -x509 -sha256 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -batch -nodes
docker run -d -p 80:80 -e PORT=8000 -e HOST=192.168.1.2 -e KEY="$(cat key.pem)" -e CERT="$(cat cert.pem)" -p 443:443 lgatica/https-proxy-alpine
```

Or use a volume

```bash
mkdir certs && cd certs
openssl req -x509 -sha256 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -batch -nodes
cd ..
docker run -d -p 80:80 -e PORT=8000 -e HOST=192.168.1.2 -v certs:/etc/ssl/private/ -p 443:443 lgatica/https-proxy-alpine
```

### When you want custom error pages

This is preconfigured to use error pages from the examples.

```bash
mkdir errors && cd errors && touch 400.http && cd ..
docker run -d -p 80:80 -e PORT=8000 -e HOST=192.168.1.2 -v errors:/usr/local/etc/haproxy/errors/ -p 443:443 lgatica/https-proxy-alpine
```

### Automatic redirection of HTTP

This image will redirect all HTTP traffic to HTTPS, but this is a job that
**should** be handled by your host in production to avoid this little overhead.

To help your host know it is proxied (because it will seem to the host like
requests come in HTTP form), all requests will have this additional
header: `X-Forwarded-Proto: https`.

You can use that to make HTTPS (`https://example.com/other-page`)
redirections, or just use relative (`../other-page`) or protocol-agnostic
(`//example.com/other-page`) redirections and it will always work
anywhere (this is a good practice, BTW).

If you don't want this forced redirection (to maintain both HTTP and HTTPS
versions of your site), just expose port 80 from your host and port 443
from the proxy.
