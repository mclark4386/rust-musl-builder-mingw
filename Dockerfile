FROM debian:stretch

MAINTAINER Matt Clark <matt@motionmobs.com>

WORKDIR /root

# common packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    ca-certificates curl file \
    build-essential \
    autoconf automake autotools-dev libtool xutils-dev cmake && \
    rm -rf /var/lib/apt/lists/*

ENV SSL_VERSION=1.0.2s

RUN curl https://www.openssl.org/source/openssl-$SSL_VERSION.tar.gz -O && \
    tar -xzf openssl-$SSL_VERSION.tar.gz && \
    cd openssl-$SSL_VERSION && ./config && make depend && make install && \
    cd .. && rm -rf openssl-$SSL_VERSION*

ENV OPENSSL_LIB_DIR=/usr/local/ssl/lib \
    OPENSSL_INCLUDE_DIR=/usr/local/ssl/include \
    OPENSSL_STATIC=1

# install toolchain
RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain stable -y

ENV PATH=/root/.cargo/bin:$PATH

ADD extra-cargo-conf /

RUN rustup target add x86_64-pc-windows-gnu && \
	rustup target add x86_64-apple-darwin && \
	bash -c 'cat /extra-cargo-conf >> ~/.cargo/config && rm /extra-cargo-conf'

