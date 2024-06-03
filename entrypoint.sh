#!/bin/bash

check_quotes() {
    local input="$1"
    if [[ "${input:0:1}" != '"' ]]; then
        if [[ "${input:0:1}" != '[' ]]; then
            input="[\"$input\"]"
        fi
    else
        input="[$input]"
    fi
    echo $input
}

# 安装 napcat
if [ ! -f "napcat/napcat.mjs" ]; then
    # 获取最新版本号
    LATEST_VERSION=$(curl -sSL https://api.github.com/repos/1244453393/QmsgNtClient-NapCatQQ/releases/latest | grep '"tag_name":' | sed -E 's/.*"tag_name":\s*"([^"]+)".*/\1/')
    # 获取架构信息
    ARCH=$(arch | sed 's/aarch64/arm64/' | sed 's/x86_64/amd64/')
    # 下载文件，设置超时为1分钟
    DOWNLOAD_URL="https://mirror.ghproxy.com/https://github.com/1244453393/QmsgNtClient-NapCatQQ/releases/download/${LATEST_VERSION}/QmsgNtClient-NapCatQQ_${ARCH}.zip"
    curl -s --max-time 60 -L $DOWNLOAD_URL -o QmsgNtClient-NapCatQQ_${ARCH}.zip

    # 检查文件是否存在并解压文件
    if [ -f QmsgNtClient-NapCatQQ_${ARCH}.zip ]; then
        # 检查zip文件是否有效
        if unzip -t QmsgNtClient-NapCatQQ_${ARCH}.zip > /dev/null 2>&1; then
            unzip -oq QmsgNtClient-NapCatQQ_${ARCH}.zip -d napcat
            chmod +x napcat/napcat.sh
            # 删除不需要的文件
            rm -f QmsgNtClient-NapCatQQ_${ARCH}.zip
            rm -f napcat/napcat.bat
            rm -f napcat/napcat.ps1
            rm -f napcat/napcat-log.ps1
            rm -f napcat/napcat-utf8.bat
            rm -f napcat/napcat-utf8.ps1
            rm -f napcat/README.md
        else
            echo "下载的文件无效，无法解压。"
            rm -f QmsgNtClient-NapCatQQ_${ARCH}.zip
        fi
    else
        echo "QmsgNtClient-NapCatQQ_${ARCH}.zip 不存在"
    fi
fi

# 如果设置为 1，则更新
if [ "${AUTO_UPDATE}" == "1" ]; then
    # 获取最新版本号
    LATEST_VERSION=$(curl -sSL https://api.github.com/repos/1244453393/QmsgNtClient-NapCatQQ/releases/latest | grep '"tag_name":' | sed -E 's/.*"tag_name":\s*"([^"]+)".*/\1/')

    # 获取本地版本号
    LOCAL_VERSION=$(grep '"version":' napcat/package.json | sed -E 's/.*"version":\s*"([^"]+)".*/v\1/')
    echo "最新版本: $LATEST_VERSION"
    echo "本地版本: $LOCAL_VERSION"

    if [ "$LATEST_VERSION" != "$LOCAL_VERSION" ]; then
        echo "版本不匹配，开始更新..."
        # 获取架构信息
        ARCH=$(arch | sed 's/aarch64/arm64/' | sed 's/x86_64/amd64/')
        
        # 下载文件，设置超时为1分钟
        DOWNLOAD_URL="https://mirror.ghproxy.com/https://github.com/1244453393/QmsgNtClient-NapCatQQ/releases/download/${LATEST_VERSION}/QmsgNtClient-NapCatQQ_${ARCH}.zip"
        curl -s --max-time 60 -L $DOWNLOAD_URL -o QmsgNtClient-NapCatQQ_${ARCH}.zip

        # 检查文件是否存在并解压文件
        if [ -f QmsgNtClient-NapCatQQ_${ARCH}.zip ]; then
            # 检查zip文件是否有效
            if unzip -t QmsgNtClient-NapCatQQ_${ARCH}.zip > /dev/null 2>&1; then
                unzip -oq QmsgNtClient-NapCatQQ_${ARCH}.zip -d napcat
                chmod +x napcat/napcat.sh
                # 删除不需要的文件
                rm -f QmsgNtClient-NapCatQQ_${ARCH}.zip
                rm -f napcat/napcat.bat
                rm -f napcat/napcat.ps1
                rm -f napcat/napcat-log.ps1
                rm -f napcat/napcat-utf8.bat
                rm -f napcat/napcat-utf8.ps1
                rm -f napcat/README.md
                echo "更新完成。"
            else
                echo "下载的文件无效，无法解压。"
                rm -f QmsgNtClient-NapCatQQ_${ARCH}.zip
            fi
        else
            echo "QmsgNtClient-NapCatQQ_${ARCH}.zip 不存在"
        fi
    else
        echo "版本匹配，不需要更新。"
    fi
else
    echo "自动更新未开启。直接启动服务器"
fi

# 设置配置文件路径
if [ -z "$ACCOUNT" ]; then
    CONFIG_PATH=config/onebot11.json
else
    CONFIG_PATH=config/onebot11_$ACCOUNT.json
fi

# 容器首次启动时执行
if [ ! -f "$CONFIG_PATH" ]; then
    : ${WEBUI_PORT:='6099'}
    : ${WEBUI_TOKEN:=$(openssl rand -base64 6 | tr -dc 'a-zA-Z0-9' | head -c 8)}
    : ${HTTP_PORT:=3000}
    : ${HTTP_URLS:='[]'}
    : ${WS_PORT:=3001}
    : ${HTTP_ENABLE:='false'}
    : ${HTTP_POST_ENABLE:='false'}
    : ${WS_ENABLE:='false'}
    : ${WSR_ENABLE:='false'}
    : ${WS_URLS:='[]'}
    : ${HEART_INTERVAL:=60000}
    : ${TOKEN:=''}
    : ${F2U_ENABLE:='false'}
    : ${DEBUG_ENABLE:='false'}
    : ${LOG_ENABLE:='false'}
    : ${RSM_ENABLE:='false'}
    : ${MESSAGE_POST_FORMAT:='array'}
    : ${HTTP_HOST:=''}
    : ${WS_HOST:=''}
    : ${HTTP_HEART_ENABLE:='false'}
    : ${MUSIC_SIGN_URL:=''}
    : ${HTTP_SECRET:=''}
    : ${QMSG_KEY:=''}
    : ${QMSG_WEBURL:='https://qmsg.zendee.cn/'}
    HTTP_URLS=$(check_quotes "$HTTP_URLS")
    WS_URLS=$(check_quotes "$WS_URLS")

    cat <<EOF > napcat/config/webui.json
{
    "port": $WEBUI_PORT,
    "token": "$WEBUI_TOKEN",
    "loginRate": 3
}
EOF

    cat <<EOF > $CONFIG_PATH
{
    "qmsg": {
      "qmsgKey": "$QMSG_KEY",
      "qmsgWebUrl": "$QMSG_WEBURL"
    },
    "http": {
      "enable": ${HTTP_ENABLE},
      "host": "$HTTP_HOST",
      "port": ${HTTP_PORT},
      "secret": "$HTTP_SECRET",
      "enableHeart": ${HTTP_HEART_ENABLE},
      "enablePost": ${HTTP_POST_ENABLE},
      "postUrls": $HTTP_URLS
    },
    "ws": {
      "enable": ${WS_ENABLE},
      "host": "${WS_HOST}",
      "port": ${WS_PORT}
    },
    "reverseWs": {
      "enable": ${WSR_ENABLE},
      "urls": $WS_URLS
    },
    "debug": ${DEBUG_ENABLE},
    "heartInterval": ${HEART_INTERVAL},
    "messagePostFormat": "$MESSAGE_POST_FORMAT",
    "enableLocalFile2Url": ${F2U_ENABLE},
    "musicSignUrl": "$MUSIC_SIGN_URL",
    "reportSelfMessage": ${RSM_ENABLE},
    "token": "$TOKEN"
}
EOF

fi

export FFMPEG_PATH=/usr/bin/ffmpeg
cd ./napcat
./napcat.sh $( [[ -n "{{ACCOUNT}}" ]] && echo "-q {{ACCOUNT}}" )