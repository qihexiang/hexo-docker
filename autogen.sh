#!/bin/bash
# autogen.sh
# Dependencies: nodejs, yarn, hexo, md5sum, git.

cd ~

if [ ! $INTERNAL_TIME ]; then
    INTERNAL_TIME=60
fi

ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=no -N $REPO_URL 
if [ ! -d .ssh ] || [ ! -f .id_rsa ]; then
    mkdir .ssh 2>/dev/null
    ssh-keygen -P "" -f ~/.ssh/id_rsa -q
    find -type d -exec chmod 700 {} \;
    find -type d -exec chmod 600 {} \;
fi

# 提醒用户将密钥添加到远程服务器，并等待60s
echo "Please install this key to your git account: "
cat ~/.ssh/id_rsa.pub
echo "Program will wait 60s before run the first process, please install the key to your target server first, and then to your git repo."
sleep 60s

# 若不存在目录，则创建并进行第一次拉取和安装
if [ ! -d hexo ]; then
    echo "First Running this Program."
    git clone $REPO_URL/$REPO_NAME hexo
    cd hexo
    yarn install
# 否则，进入目录
else
    cd hexo
fi

hexo server &

while true
do
    git pull
    result=$(md5sum .git/refs/heads/master | cut -d " " -f 1)
    if [ ! $md5 ]; then
        md5=$result
    fi
    if [ $md5 != $result ]; then
        echo "Updating Content"
        md5=$result
    fi
    sleep $INTERNAL_TIME\s
done