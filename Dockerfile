FROM ubuntu:22.04

WORKDIR /app

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y make git zlib1g-dev libssl-dev gperf cmake clang-14 libc++-dev libc++abi-dev

COPY /telegram-bot-api/CMakeLists.txt .
COPY /telegram-bot-api/td ./td
COPY /telegram-bot-api/telegram-bot-api ./telegram-bot-api

WORKDIR /app/build

RUN CXXFLAGS="-stdlib=libc++" CC=/usr/bin/clang-14 CXX=/usr/bin/clang++-14 cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=.. .. && \
    cmake --build . --target install

EXPOSE 8081/tcp 8082/tcp

HEALTHCHECK \
    --interval=5s \
    --timeout=30s \
    --retries=3 \
    CMD nc -z localhost 8081 || exit 1

ENTRYPOINT ["/app/build"]
