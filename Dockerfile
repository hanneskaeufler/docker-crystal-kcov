FROM crystallang/crystal:0.27.0 AS builder

RUN apt-get update && \
    apt-get install -y --fix-missing pkg-config && \
    apt-get install -y \
        binutils-dev \
        build-essential \
        cmake \
        git \
        libcurl4-openssl-dev \
        libdw-dev \
        libiberty-dev \
        ninja-build \
        python \
        zlib1g-dev \
        ;

RUN git clone https://github.com/SimonKagstrom/kcov.git /tmp && cd /tmp && git checkout v36

RUN mkdir -p /tmp/kcov-build && \
    cd /tmp/kcov-build && \
    cmake .. && \
    make && \
    make install

# ensure we don't copy any unneeded libs into final image
RUN apt-get purge -y \
        binutils-dev \
        build-essential \
        cmake \
        git \
        libcurl4-openssl-dev \
        libdw-dev \
        libiberty-dev \
        ninja-build \
        python \
        zlib1g-dev \
        && \
    apt-get autoremove -y && \
    apt-get autoclean -y

RUN apt-get update && \
    apt-get install -y \
        binutils \
        libcurl3 \
        libdw1 \
        zlib1g \
        ;

FROM crystallang/crystal:0.27.0
COPY --from=builder /lib/x86_64-linux-gnu/*.so* /lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/*.so* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/local/bin/kcov* /usr/local/bin/

CMD ["/usr/local/bin/kcov"]
