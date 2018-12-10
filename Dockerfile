FROM golang:1.10-alpine
RUN apk --no-cache add \
    protobuf \
    openjdk8 \
    curl \
    git \
    bash \
    make \
    build-base \
    libtool
RUN mkdir -p /chaincode/input /chaincode/output
