# https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
# https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
# https://kernel.ubuntu.com/~kernel-ppa/config/

FROM ubuntu:jammy
LABEL maintainer="Hui Chun Ong"

ENV PACKAGES bison \
    bc \
    build-essential \
    cpio \
    curl \
    fakeroot \
    flex \
    git \
    kmod \
    libelf-dev \
    libssl-dev \
    ncurses-dev  \
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
COPY .config ${BASE}/src/.config

WORKDIR ${BASE}/src

RUN git apply ${BASE}/patches/*.patch &>/dev/null && \
    echo "" | make ARCH=x86_64 olddefconfig && \
    LOCAL_VERSION=$(awk -F '=' '/^LOCAL_VERSION/{print $NF}' ${BASE}/conf); \
    make ARCH=x86_64 -j$(nproc) LOCALVERSION=${LOCAL_VERSION} bindeb-pkg && \
    mkdir /build && \
    cp ../*.deb /build