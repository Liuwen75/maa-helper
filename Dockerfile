# 使用轻量级的 Ubuntu 作为基础镜像
FROM ubuntu:22.04

# 避免安装过程中的交互式界面
ENV DEBIAN_FRONTEND=noninteractive

# 更新软件源，安装必要工具：wget、unzip、adb
RUN apt-get update && \
    apt-get install -y wget unzip adb && \
    rm -rf /var/lib/apt/lists/*

# 下载最新版 MAA CLI（以 x86_64 为例）
RUN wget https://github.com/MaaAssistantArknights/MaaAssistantArknights/releases/download/v5.12.3/MAA-v5.12.3-linux-x86_64.tar.gz && \
    tar -zxvf MAA-v5.12.3-linux-x86_64.tar.gz && \
    mv MAA-v5.12.3-linux-x86_64 /maa && \
    rm MAA-v5.12.3-linux-x86_64.tar.gz

# 创建配置目录
RUN mkdir -p /maa/config

# 容器启动时，进入 /maa 目录并运行 MAA
WORKDIR /maa
CMD ["./maa", "run"]
