FROM golang:1.13.4-alpine3.10 as builder

LABEL company="Pharos Production Inc."
LABEL version="2.3.0"

ENV LANG=C.UTF-8 \
  REFRESHED_AT=2019-11-26-1 \
  DEBIAN_FRONTEND=noninteractive

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /go-ethereum
RUN cd /go-ethereum && make geth bootnode

#############################################################

FROM alpine:3.10

LABEL company="Pharos Production Inc."
LABEL version="2.3.0"

ENV LANG=C.UTF-8 \
  REFRESHED_AT=2019-11-26-1 \
  DEBIAN_FRONTEND=noninteractive

RUN apk add --no-cache \
  ca-certificates \
  bash \
  tzdata \ 
  openntpd

COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/
COPY --from=builder /go-ethereum/build/bin/bootnode /usr/local/bin/

COPY ./scripts/quorum.sh /opt/blockchain/quorum/
RUN chmod +x /opt/blockchain/quorum/quorum.sh

CMD [ "/bin/bash" ]
