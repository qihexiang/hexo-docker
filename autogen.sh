#!/bin/bash
# autogen.sh
# Dependencies: nodejs, yarn, hexo, git, nginx.

cd ~

nginx

if [ ! $REPO_NAME ] || [ ! $REPO_URL ]; then
    echo "Please give full information of the repo."
    exit 1
fi

if [ ! $INTERNAL_TIME ]; then
    INTERNAL_TIME=60
fi

if [ ! $BRANCH ]; then
    BRANCH="master"
fi

ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=no -N $REPO_URL 
if [ ! -d .ssh ] || [ ! -f .ssh/id_rsa ]; then
    mkdir .ssh 2>/dev/null
    ssh-keygen -P "" -f ~/.ssh/id_rsa -q
    find -type d -exec chmod 700 {} \;
    find -type d -exec chmod 600 {} \;
    # 提醒用户将密钥添加到远程服务器，并等待60s
    echo "Please install this key to your git account: "
    cat ~/.ssh/id_rsa.pub
    echo "Program will wait 60s before run the first process, please install the key to your git repo."
    sleep 60s
else
    echo "SSH Key is: "
    cat ~/.ssh/id_rsa.pub
fi

cd /var/www/html

# 若不存在目录，则创建并进行第一次拉取和安装
if [ ! -d hexo ]; then
    echo "First Running this Program."
    git clone -b $BRANCH $REPO_URL/$REPO_NAME hexo
    cd hexo
    yarn install
# 否则，进入目录
else
    cd hexo
fi

hexo clean
hexo generate
chown -R www-data public

while true
do
    git pull 2>/dev/null
    result=$(cat .git/refs/heads/$BRANCH)
    if [ ! $md5 ]; then
        md5=$result
    fi
    if [ $md5 != $result ]; then
        echo "Updating Content at $(date)"
        hexo clean
        hexo generate
        nginx -s reload
        md5=$result
    else
        echo "Checked at $(date)"
    fi
    sleep $INTERNAL_TIME\s
done