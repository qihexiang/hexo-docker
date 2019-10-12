# Hexo in Docker

自动通过Git拉取Hexo的Git仓库，自动生成静态文件后通过Nginx从4000端口提供访问。

## 使用方法

假设Git仓库在gitlab.buctsnc.cn/root/xware.buctsnc.cn.git

构建镜像：

```bash
docker build -t hexo-docker .
```

启动容器：

```bash
docker run -i \
--name hexo-docker \
-e REPO_URL="ssh://git@gitlab.buctsnc.cn" \
-e REPO_NAME="root/xware.buctsnc.cn.git" \
-e BRANCH="master" \
-e INTERNAL_TIME=600 \
-p 127.0.0.1:4000:4000
localhost:5000/hexo-docker:latest
```

然后使用反向代理将127.0.0.1:4000端口映射出去即可。

## 环境变量表

变量名|含义|格式|默认值|例子
---|---|---|---|---
REPO_URL|Git仓库的SSH地址|ssh://username@hostname|无|ssh://git@gitlab.buctsnc.cn
REPO_NAME|Git仓库的完整名称|path/to/git/repo.git|无|root/xware.buctsnc.cn
BRANCH|Git仓库分支|branch-name|master|master
INTERNAL_TIME|两次同步的间隔时间（秒）|精确到毫秒|60|600
