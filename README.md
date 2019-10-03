# Hexo生成工具

本工具可以从Git仓库中更新Hexo源文件，并生成静态文件发送到目标服务器。根据设置的间隔时间，系统将会自动地从Git仓库更新文件，如果有更新，就会生成新的静态文件，并替换掉旧的文件。

简而言之，当第一次部署完毕之后，用户只需要将写好的博客git push到自己的仓库中即可。

下面范例将说明如何Github上的仓库qihexiang/xware.buctsnc.cn生成到xware.buctsnc.cn服务器的/var/www/xware目录。

## 使用

构建（需要使用网络）：

```bash
docker build -t xware .
```

运行（首次生成需要网络）：

```bash
docker run -i --name XWARE \
-e INTERNAL_TIME=[检查间隔时间] \
-e REPO_URL=[Git仓库所在服务器SSH登录信息] \
-e REPO_NAME=[Git仓库的名称，例如xware.git] \
-e TARGET_SRV=[目标服务器SSH登录信息] \
-e TARGET_DIR=[目标服务器上的目标目录] \
-e SELINUX=[on|off] \
xware:latest
```

> Windows不支持折行语法，请在同一行内输入全部内容

启动后，系统会自动生成SSH密钥对，将显示的公钥安装到Git仓库和目标服务器即可。第一次传输完成后，可以按Ctrl+C分离Docker界面。

## 远程服务器设置

对于远程的Web服务器，需要进行一些设置来保证自动化部署和安全。

1. 创建用户，建议为本服务创建单独的用户，并且设置非密码登录，来提高安全性。
2. 配置目标目录的安全属性，包括DAC属性和MAC属性（SELinux），保证下面两点：
   - 用户对目录有写入的能力
   - 服务器对目录有读取的能力

操作示范：

```bash
$ sudo useradd -m xware
$ sudo -u xware bash
$ cd /home/xware
$ echo $SSH_PUBLIC_KEY >> .ssh/authorized_keys
$ exit
$ sudo mkdir /var/www/xware
$ sudo chown xware:nginx /var/www/xware
$ sudo restorecon -R /var/www/*
```

## 环境变量表

变量名|意义|值类型|默认值|范例
---|---|---|---|---
INTERNAL_TIME|两次检查间隔的时间（秒）|浮点数/整型数|60|60
SELINUX|SELinux状态|on/off|off|off
REPO_URL|Git仓库所在服务器的SSH地址|字符串|无|git@github.com
REPO_NAME|Git仓库所在的路径|字符串|无|qihexiang/xware.buctsnc.cn.git
TARGET_SRV|目标服务器的SSH地址|字符串|无|xware@xware.buctsnc.cn
TARGET_DIR|目标服务器目录|字符串|无|/var/www/xware
