FROM python:3.10-slim-bullseye

ARG BAZEL_VERSION=6.0.0-pre.20220601.1
ARG ARCH=linux-x86_64
ARG LLVM_VERSION=14
ARG LLVM_ARCH=linux-amd64
ARG APT_PKGS="\
    cmake \
    curl \
    docker.io \
    fuse \
    git \
    gnupg2 \
    jq \
    less \
    lsb-release \
    net-tools \
    ninja-build \
    rlwrap \
    rsync \
    socat \
    wget"
ARG CLANG_PKGS="\
    clang-format-${LLVM_VERSION} \
    clang-tidy-${LLVM_VERSION} \
    clang-tools-${LLVM_VERSION} \
    clang-${LLVM_VERSION} \
    lld-${LLVM_VERSION} \
    lldb-${LLVM_VERSION} \
    llvm-${LLVM_VERSION} \
    python3-clang-${LLVM_VERSION}"
ARG BAZEL_TOOLS_VERSION=5.1.0
ARG USERNAME=worker

ENV PYTHONASYNCIODEBUG=1
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://deb.debian.org/debian bullseye-backports main contrib non-free" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -t bullseye-backports --no-install-recommends -y -qq $APT_PKGS \
    && echo "deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-${LLVM_VERSION} main" >> /etc/apt/sources.list \
    && echo "deb-src http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-${LLVM_VERSION} main" >> /etc/apt/sources.list \
    && wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && apt-get update \
    && apt-get install -t bullseye-backports -y -qq $CLANG_PKGS \
    && wget -qO - "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-${ARCH}" > /usr/local/bin/bazel \
    && chmod +x /usr/local/bin/bazel \
    && wget -qO - "https://github.com/bazelbuild/buildtools/releases/download/${BAZEL_TOOLS_VERSION}/buildifier-${LLVM_ARCH}" > /usr/local/bin/buildifier \
    && chmod +x /usr/local/bin/buildifier \
    && wget -qO - "https://github.com/bazelbuild/buildtools/releases/download/${BAZEL_TOOLS_VERSION}/buildozer-${LLVM_ARCH}" > /usr/local/bin/buildozer \
    && chmod +x /usr/local/bin/buildozer \
    && mkdir -p /src/workspace \
    && useradd -ms /bin/bash $USERNAME \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src/workspace
USER $USERNAME
