# 使用轻量级的 Ubuntu 作为基础镜像
FROM ubuntu:22.04

# 避免安装过程中的交互式界面
ENV DEBIAN_FRONTEND=noninteractive

# 安装编译 MAA 所需的依赖
RUN apt-get update && \
    apt-get install -y \
        git \
        build-essential \
        cmake \
        ninja-build \
        libopencv-dev \
        libz-dev \
        libsqlite3-dev \
        libcurl4-openssl-dev \
        adb \
        wget \
        unzip \
        software-properties-common \
        gpg \
    && rm -rf /var/lib/apt/lists/*

# 升级 CMake 到最新版本（MAA 需要 3.28+）
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | tee /etc/apt/sources.list.d/kitware.list && \
    apt-get update && \
    apt-get install -y cmake && \
    rm -rf /var/lib/apt/lists/*

# 克隆 MAA 源码
WORKDIR /build
RUN git clone --depth 1 https://github.com/MaaAssistantArknights/MaaAssistantArknights.git

# 编译 MAA
WORKDIR /build/MaaAssistantArknights/build
RUN cmake -GNinja .. && \
    ninja && \
    ninja install

# 将编译好的 MAA 复制到最终目录
RUN mkdir -p /maa
RUN cp /usr/local/bin/maa /maa/ || true

# 创建配置目录
RUN mkdir -p /maa/config

# 设置工作目录
WORKDIR /maa

# 容器启动时运行 MAA
CMD ["./maa", "run"]
