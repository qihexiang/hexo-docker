# Hexo生成工具

本工具可以从Git仓库中更新Hexo源文件，并生成静态文件发送到目标服务器。

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
-e SELINUX=[on|off]
xware:latest
```

> Windows不支持折行语法，请在同一行内输入全部内容

启动后，系统会自动生成SSH密钥对，将显示的公钥安装到Git仓库和目标服务器即可。

目标服务器上的目标目录（需要提前建好）需要登陆用户具有写入权限，同时要确认正确的SELinux（如果开启）上下文，例如xware@xware.buctsnc.cn上，应是这样：

```
drwxr-xr-x. 10 xware nginx unconfined_u:object_r:httpd_sys_content_t:s0 152 Oct  1 07:33 xware
```

第一次传输完成后，可以按Ctrl+C分离Docker界面。

## 环境变量表

范例：将Github上的仓库qihexiang/hexo生成到xware.buctsnc.cn服务器（Ubuntu）的/var/www/xware目录。

变量名|意义|值类型|默认值|范例
---|---|---|---|---
INTERNAL_TIME|两次检查间隔的时间（秒）|浮点数/整型数|60|60
SELINUX|SELinux状态|on/off|off|off
REPO_URL|Git仓库所在服务器的SSH地址|字符串|无|git@github.com
REPO_NAME|Git仓库所在的路径|字符串|无|qihexiang/xware.buctsnc.cn.git
TARGET_SRV|目标服务器的SSH地址|字符串|无|xware@xware.buctsnc.cn
TARGET_DIR|目标服务器目录|字符串|无|/var/www/xware
