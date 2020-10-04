FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
RUN chmod 1777 /tmp
RUN apt update -y && apt install -y \
	u-boot-tools \
	cpio \
	gzip \
	device-tree-compiler \
	make \
	git \
	build-essential \
	gcc \
	bison \
	flex \
	python3 \
	python3-distutils \
	python3-dev \
	swig \
	make \
	python \
	python-dev \
	bc \
	ash \
  && rm -rf /var/lib/apt/lists/*

RUN /bin/ash -c 'set -ex && \
    ARCH=`uname -m` && \
    if [ "$ARCH" != "aarch64" ]; then \
	echo "x86_64" && \
	apt install -y gcc-aarch64-linux-gnu; \
    fi'

WORKDIR /build
VOLUME /out

COPY . /build

RUN find /build/ -type f -iname "*.sh" -exec chmod +x {} \;

ARG DISTRO
ENV DISTRO=${DISTRO}
ARG PARTNUM
ENV PARTNUM=${PARTNUM}
ARG HEKATE_ID
ENV HEKATE_ID=${HEKATE_ID}
ENV CROSS_COMPILE=aarch64-linux-gnu-
ENV ARCH=arm64
ARG CPUS=2
ENV CPUS=${CPUS}

CMD /build/scripts/entrypoint.sh /out
