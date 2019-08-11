FROM debian:stretch-slim as builder

ENV GIT_BRANCH=v2.0.6

# Install build dependencies
# Separate layer so we can cache things
RUN set -x && \
    apt-get update && \
    apt-get -y install \
      build-essential \
      pkg-config \
      libc6-dev \
      m4 \
      g++-multilib \
      autoconf \
      libtool \
      ncurses-dev \
      unzip \
      git \
      python \
      python-zmq \
      zlib1g-dev \
      wget \
      bsdmainutils \
      automake && \
    rm -rf /var/lib/apt/lists/* 

# Clone repo and do Sprout proving
RUN set -x && \
    git clone https://github.com/zcash/zcash.git /tmp/zcash && \
    cd /tmp/zcash && \
    git checkout ${GIT_BRANCH} && \
    bash zcutil/fetch-params.sh

# Build the app
RUN set -x && \
    apt-get update && \
    apt-get install -y curl && \
    cd /tmp/zcash && \
    bash zcutil/build.sh -j$(nproc)

# Copy binaries and libs from builder to a separate image
FROM debian:stretch-slim

RUN  mkdir -p /zcash/data && \
     mkdir -p /root/.zcash
WORKDIR /usr/local/bin
COPY --from=builder /usr/lib/x86_64-linux-gnu/libgomp.so.1 /lib/x86_64-linux-gnu/libgomp.so.1
COPY --from=builder /tmp/zcash/src/zcashd .
COPY --from=builder /tmp/zcash/src/zcash-cli .
COPY --from=builder /root/.zcash-params /root/.zcash-params

# Use custom entrypoint
WORKDIR /zcash
COPY docker-entrypoint.sh /zcash/docker-entrypoint.sh
ENTRYPOINT [ "/zcash/docker-entrypoint.sh" ]
