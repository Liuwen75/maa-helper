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
    && rm -rf /var/lib/apt/lists/*

# 克隆 MAA 源码（使用国内镜像加速，如果慢可以去掉后面的 --depth 1）
WORKDIR /build
RUN git clone --depth 1 https://github.com/MaaAssistantArknights/MaaAssistantArknights.git

# 编译 MAA
WORKDIR /build/MaaAssistantArknights/build
RUN cmake -GNinja .. && \
    ninja && \
    ninja install

# 将编译好的 MAA 复制到最终目录
RUN mkdir -p /maa
RUN cp -r /usr/local/bin/maa* /maa/ || true
RUN cp -r /usr/local/lib/libmaa* /maa/ || true

# 创建配置目录
RUN mkdir -p /maa/config

# 设置工作目录
WORKDIR /maa

# 容器启动时运行 MAA
CMD ["./maa", "run"]
