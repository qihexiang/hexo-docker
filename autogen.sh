#!/bin/bash
# autogen.sh
# Dependencies: nodejs, yarn, hexo, md5sum, git.

cd ~

if [ ! $INTERNAL_TIME ]; then
    INTERNAL_TIME=60
fi

if [ ! $SELINUX ]; then
    SELINUX=off
fi

# 接受所有的远程服务器SSH Host Key
ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=no -N -q $REPO_URL 
ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=no -N -q $TARGET_SRV

# 建立本机的SSH密钥对
if [ ! -d .ssh ] || [ ! -f .id_rsa ]; then
    mkdir .ssh 2>/dev/null
    ssh-keygen -P "" -f ~/.ssh/id_rsa -q
    find -type d -exec chmod 700 {} \;
    find -type d -exec chmod 600 {} \;
fi

# 提醒用户将密钥添加到远程服务器，并等待60s
echo "Please install this key to your target server and git repo: "
cat ~/.ssh/id_rsa.pub
echo "Program will wait 60s before run the first process, please install the key to your target server first, and then to your git repo."
sleep 60s

function publish() {
    echo "clean files"
    ssh $TARGET_SRV rm -rf $TARGET_DIR/*
    echo "transport files"
    scp -r public/* $TARGET_SRV:$TARGET_DIR/
    if [ $SELINUX == on ]; then
        echo "fix security context"
        ssh $TARGET_SRV restorecon -R $TARGET_SRV
    fi
}

while true
do
    if [ ! -d hexo ]; then
        echo "First Running this Program."
        git clone $REPO_URL:$REPO_NAME hexo
        cd hexo
        yarn install
        hexo g
        publish
    else
        cd hexo
        git pull
        result=$(md5sum .git/refs/heads/master | cut -d " " -f 1)
        if [ ! $md5 ]; then
            md5=$result
        fi
        if [ $md5 != $result ]; then
            echo "Updating Content"
            hexo g
            publish
            md5=$result
        fi
    fi
    sleep $INTERNAL_TIME\s
    cd ~
done