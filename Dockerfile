# docker build -t danos-1908-build -f Dockerfile .
# docker run --rm -v $PWD:/mnt/src -v $PWD:/mnt/output  danos-1908-build
FROM debian:stretch

RUN mkdir -p '/mnt/src' && \
    mkdir -p '/mnt/output' && \
    mkdir -p '/mnt/pkgs' && \
    mkdir -p /build && \
    groupadd -g 1000 builduser && \
    useradd -r -u 1000 -g builduser -d /home/builduser -m builduser && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install build-essential devscripts wget && \
    echo "deb http://s3-us-west-1.amazonaws.com/repos.danosproject.org/standard/ 1908 main" > /etc/apt/sources.list.d/danos.list && \
    echo "deb http://s3-us-west-1.amazonaws.com/repos.danosproject.org/bootstrap/ 1908 main" >> /etc/apt/sources.list.d/danos.list && \
    wget -q -O- https://s3-us-west-1.amazonaws.com/repos.danosproject.org/Release.key | apt-key add - && \
    apt-get update

COPY buildpackage /usr/local/bin

WORKDIR /build/src

ENTRYPOINT /usr/local/bin/buildpackage
