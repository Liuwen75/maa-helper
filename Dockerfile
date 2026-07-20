# 使用轻量级的 Ubuntu 作为基础镜像
FROM ubuntu:22.04

# 避免安装过程中的交互式界面
ENV DEBIAN_FRONTEND=noninteractive

# 安装必要工具：wget、unzip、adb
RUN apt-get update && \
    apt-get install -y wget unzip adb && \
    rm -rf /var/lib/apt/lists/*

# 下载 MAA 预编译 Linux 版本
# 使用官方 Release 页面的正确下载链接
RUN wget -O MAA.tar.gz https://github.com/MaaAssistantArknights/MaaAssistantArknights/releases/latest/download/MAA-v5.12.3-linux-x86_64.tar.gz && \
    tar -zxvf MAA.tar.gz && \
    mv MAA-v5.12.3-linux-x86_64 /maa && \
    rm MAA.tar.gz

# 创建配置目录
RUN mkdir -p /maa/config

# 设置工作目录
WORKDIR /maa

# 容器启动时运行 MAA
CMD ["./maa", "run"]
