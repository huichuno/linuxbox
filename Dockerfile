# https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
# https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
# https://kernel.ubuntu.com/~kernel-ppa/config/

FROM ubuntu:focal
LABEL maintainer="Hui Chun Ong"

ENV PACKAGES bison \
    build-essential \
    curl \
    fakeroot \
    flex \
    git \
    kernel-package \
    libelf-dev \
    libncurses5-dev \
    libssl-dev \
    liblz4-tool \
    rsync \
    xz-utils

RUN apt-get update && \
    apt-get -y -q upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -y -q install ${PACKAGES} && \
    apt-get clean

ENV BASE=/project/linux

WORKDIR ${BASE}
RUN dpkg -l ${PACKAGES} | sort > packages.txt

COPY conf ${BASE}/conf

RUN REPO_URL=$(awk -F '=' '/^REPO_URL/{print $NF}' ${BASE}/conf); \
    BRANCH=$(awk -F '=' '/^BRANCH/{print $NF}' ${BASE}/conf); \ 
    git config --global advice.detachedHead false && \ 
    git clone --depth 1 ${REPO_URL} --branch ${BRANCH} --single-branch src

COPY patches ${BASE}/patches

WORKDIR ${BASE}/src

RUN CONFIG_URL=$(awk -F '=' '/^CONFIG_URL/{print $NF}' ${BASE}/conf); \
    git apply ${BASE}/patches/*.patch &>/dev/null && \
    curl ${CONFIG_URL} -o .config && \   
    yes ""|make oldconfig
 
RUN APPEND_VER=$(awk -F '=' '/^APPEND_VER/{print $NF}' ${BASE}/conf); \ 
    REVISION=$(awk -F '=' '/^REVISION/{print $NF}' ${BASE}/conf); \
    CONCURRENCY_LEVEL=$(nproc); \
    fakeroot make-kpkg --initrd --append-to-version=${APPEND_VER} --revision=${REVISION} --overlay-dir=/usr/share/kernel-package kernel_image kernel_headers && \
    mkdir /build && cp ../*.deb /build
