---
hide:
  - toc
---

# Docker

## 说明

SmartDNS提供了Docker镜像方便进行快速安装。

## 配置

创建配置文件/etc/smartdns/smartdns.conf，添加如下必须的配置项目：

```
bind [::]:53
server 8.8.8.8
server 1.1.1.1
```

## 启动镜像

```
docker run -d --name smartdns --restart=always -p 53:53/udp -v /etc/smartdns:/etc/smartdns pymumu/smartdns:latest
```