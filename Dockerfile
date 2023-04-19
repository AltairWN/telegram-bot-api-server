FROM alpine:latest

LABEL maintainer="AltairWN"
LABEL version="1.0.0"

RUN apk update && apk upgrade

RUN apk add --update alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake

WORKDIR /app

RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git

WORKDIR /app/telegram-bot-api/build

RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .. && \
    cmake --build . --target install

EXPOSE 8081/tcp 8082/tcp

ENTRYPOINT ["/usr/local/bin/telegram-bot-api"]
