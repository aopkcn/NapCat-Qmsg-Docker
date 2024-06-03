<div align="center">
  <img src="https://socialify.git.ci/NapNeko/NapCatQQ/image?description=1&language=1&logo=https%3A%2F%2Fraw.githubusercontent.com%2FNapNeko%2FNapCatQQ%2Fmain%2Flogo.png&name=1&stargazers=1&theme=Auto" alt="NapCatQQ" width="320" height="320" />
  <img src="https://qmsg.zendee.cn/img/icon.png" alt="qmsg" width="320" height="320" />
</div>


# NapCat-Qmsg-Docker

 - [DockerHub](https://hub.docker.com/aopkcn/napcat:qmsg)
    * `docker.io/aopkcn/napcat:qmsg`

 - [GHCR](https://ghcr.io/aopkcn/napcat:qmsg)
   * `ghcr.io/aopkcn/napcat:qmsg`

 - [阿里云]()
   * `registry.cn-chengdu.aliyuncs.com/aopkcn/napcat:qmsg`

## Support Platform/Arch
- [x] Linux/Amd64

## 配置

容器通过环境变量来配置，环境变量名称可以查看 [entrypoint](./entrypoint.sh)👈

具体参数可参考[NapCatQQ官方文档](https://napneko.github.io/zh-CN/guide/getting-started)[Qmsg酱官方文档](https://qmsg.zendee.cn/docs/)

# 启动容器
## QMSG

```shell
docker run -d \
-e ACCOUNT=<机器人qq> \
-e AUTO_UPDATE=<设置1开启自动更新> \
-e WEBUI_TOKEN=<qmsg密钥> \
-e WS_ENABLE=true \
-p 6099:6099 \
--name napcat \
--restart=always \
aopkcn/napcat:qmsg
```

```yaml
# docker compose QMSG
version: "3"
services:
    napcat:
        environment:
            - ACCOUNT=<机器人qq>
            - AUTO_UPDATE=<设置1开启自动更新>
            - WEBUI_TOKEN=<qmsg密钥>
        ports:
            - 6099:6099
        container_name: napcat
        network_mode: bridge
        restart: always
        image: aopkcn/napcat:qmsg
```
## 正向 WS
<details>
<summary>点我查看命令👈</summary>

```shell
docker run -d \
-e ACCOUNT=<机器人qq> \
-e WS_ENABLE=true \
-p 3001:3001 \
-p 6099:6099 \
--name napcat \
--restart=always \
aopkcn/napcat:qmsg
```

```yaml
# docker compose 正向 WS
version: "3"
services:
    napcat:
        environment:
            - ACCOUNT=<机器人qq>
            - WS_ENABLE=true
        ports:
            - 3001:3001
            - 6099:6099
        container_name: napcat
        network_mode: bridge
        restart: always
        image: aopkcn/napcat:qmsg
```
</details>

## 反向 WS
<details>
<summary>点我查看命令👈</summary>

```shell
docker run -d \
-e ACCOUNT=<机器人qq> \
-e WSR_ENABLE=true \
-e WS_URLS='["ws://192.168.3.8:5140/onebot"]' \
--name napcat \
--restart=always \
aopkcn/napcat:qmsg
```

```yaml
# docker compose 反向 WS
version: "3"
services:
    napcat:
        environment:
            - ACCOUNT=<机器人qq>
            - WSR_ENABLE=true
            - WS_URLS=["ws://192.168.3.8:5140/onebot"]
        container_name: napcat
        network_mode: bridge
        ports:
           - 6099:6099
        restart: always
        image: aopkcn/napcat:qmsg
```
</details>

## HTTP
<details>
<summary>点我查看命令👈</summary>

```shell
docker run -d \
-e ACCOUNT=<机器人qq> \
-e HTTP_ENABLE=true \
-e HTTP_POST_ENABLE=true \
-e HTTP_URLS='["http://192.168.3.8:5140/onebot"]' \
-p 3000:3000 \
-p 6099:6099 \
--name napcat \
--restart=always \
aopkcn/napcat:qmsg
```

```yaml
# docker compose HTTP POST
version: "3"
services:
    napcat:
        environment:
            - ACCOUNT=<机器人qq>
            - HTTP_ENABLE=true
            - HTTP_POST_ENABLE=true
            - HTTP_URLS=["http://192.168.3.8:5140/onebot"]
        ports:
            - 3000:3000
            - 6099:6099
        container_name: napcat
        network_mode: bridge
        restart: always
        image: aopkcn/napcat:qmsg
```
</details>

# 固化路径，方便下次直接快速登录

QQ 文档路径：~/.config/QQ

NapCat与Qmsg 配置文件路径: /usr/src/app/napcat/config

注意：如果是重新创建的容器，需要固定 Mac 地址

# 登录

```shell
docker logs napcat
```
# 浏览器访问登录
```WEBUI
<IP>:<端口>/webui
```