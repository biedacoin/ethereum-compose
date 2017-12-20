FROM alpine:3.7 as build

RUN apk --no-cache add go git cmake make gcc g++ musl-dev boost-dev linux-headers ca-certificates

RUN git clone --depth=1 --recursive https://github.com/ethereum/solidity.git /tmp/solidity
RUN mkdir -p /tmp/solidity/build/ \
 && cd /tmp/solidity/build/ \
 && cmake .. \
 && make -j4

RUN git clone --depth=1 https://github.com/ethereum/go-ethereum /tmp/go-ethereum
RUN cd /tmp/go-ethereum && make all

###

FROM alpine:3.7

RUN apk --no-cache add jq curl ca-certificates boost

COPY --from=build /tmp/solidity/build/solc/solc /usr/local/bin/
COPY --from=build /tmp/go-ethereum/build/bin/*  /usr/local/bin/

WORKDIR /root/.ethereum/

ARG N_ACCOUNTS=8
ENV N_ACCOUNTS=${N_ACCOUNTS}

COPY docker/geth-genesis.sh /geth-genesis.sh
RUN /geth-genesis.sh

COPY docker/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

COPY docker/geth-start.sh /
CMD /geth-start.sh

# vim:ts=2:sw=2:et:syn=dockerfile:
