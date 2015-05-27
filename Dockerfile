FROM alpine:3.1
MAINTAINER Jose Monreal <jmonreal@gmail.com>

RUN apk update \
    && apk upgrade \
    && apk add make wget go git gcc musl-dev openssl-dev bash libgcc \
    && export GOPATH=/go \
    && go get -u -v github.com/hashicorp/consul \
    && cd /go/src/github.com/hashicorp/consul \
    && git checkout v0.5.2 \
    && make \
    && mv bin/consul /bin/ \
    && cd /tmp \
    && rm -rf /go \
    && wget -O ui.zip http://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip \
    && unzip ui.zip \
    && mv dist /ui \
    && rm ui.zip \
    && apk del make wget go git gcc musl-dev openssl-dev bash libgcc \
    && rm -rf /var/cache/apk/* \\
    && mkdir -p /var/run/consul/{data,config}

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp

VOLUME ["/var/run/consul/data", "/var/run/consul/config"]

ENTRYPOINT ["/bin/consul"]

CMD []
