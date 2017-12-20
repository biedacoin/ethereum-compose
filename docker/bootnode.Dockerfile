FROM alpine:3.7 as build

RUN apk --no-cache add go git make gcc musl-dev linux-headers ca-certificates

RUN git clone --depth=1 https://github.com/ethereum/go-ethereum /tmp/go-ethereum
RUN cd /tmp/go-ethereum && make all

###

FROM alpine:3.7

RUN apk --no-cache add curl ca-certificates

COPY --from=build /tmp/go-ethereum/build/bin/* /usr/local/bin/

WORKDIR /root/.ethereum/

COPY docker/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

COPY docker/bootnode-start.sh /
CMD /bootnode-start.sh

# vim:ts=2:sw=2:et:syn=dockerfile:
