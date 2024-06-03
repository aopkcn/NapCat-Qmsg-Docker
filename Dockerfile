# 基础镜像
FROM debian:12-slim
LABEL author="蝼蚁梦" maintainer="aopkcn@qq.com"
# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
#换国内源
#sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
# 安装必要的软件包
RUN apt-get update \
    && apt-get install -y \
    libnss3 \
    libnotify4 \
    libsecret-1-0 \
    libgbm1 \
    libasound2 \
    fonts-wqy-zenhei \
    gnutls-bin \
    libglib2.0-dev \
    libdbus-1-3 \
    libgtk-3-0 \
    libxss1 \
    libxtst6 \
    libatspi2.0-0 \
    libx11-xcb1 \
    ffmpeg \
    unzip \
    curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

WORKDIR /usr/src/app

# 复制必要的文件
COPY entrypoint.sh .

# 安装Linux QQ
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
    #curl -o linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.8_240520_${arch}_01.deb && \
    #境外下载QQ特别慢使用自建的下载
    curl -o linuxqq.deb https://a.aopk.cn:444/QQ_3.2.8_240520_${arch}_01.deb && \
    dpkg -i --force-depends linuxqq.deb && rm linuxqq.deb && \
    chmod +x entrypoint.sh

# 定义持久化存储卷
VOLUME /usr/src/app/napcat/config
VOLUME /root/.config/QQ

# 设置入口点
ENTRYPOINT ["bash", "entrypoint.sh"]
