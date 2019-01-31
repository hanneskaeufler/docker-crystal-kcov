FROM kcov/kcov:v36

RUN apt-get update && \
    apt-get install -y curl openssl bash apt-transport-https ca-certificates

RUN curl -sSL https://dist.crystal-lang.org/apt/setup.sh | bash
RUN apt-get install -y --allow-unauthenticated crystal
