FROM golang:1.11-alpine as builder

LABEL company="Pharos Production Inc."
LABEL version="2.2.3"

ENV LANG=C.UTF-8 \
  REFRESHED_AT=2019-08-07-1
ENV DEBIAN_FRONTEND noninteractive

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /go-ethereum
RUN cd /go-ethereum && make geth bootnode

#############################################################

FROM alpine:3.9.4

LABEL company="Pharos Production Inc."
LABEL version="2.2.3"

ENV LANG=C.UTF-8 \
  REFRESHED_AT=2019-08-07-1
ENV DEBIAN_FRONTEND noninteractive

RUN apk add --no-cache ca-certificates bash

COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/
COPY --from=builder /go-ethereum/build/bin/bootnode /usr/local/bin/

COPY ./scripts/quorum.sh /opt/blockchain/quorum/
RUN chmod +x /opt/blockchain/quorum/quorum.sh

CMD [ "/bin/bash" ]
