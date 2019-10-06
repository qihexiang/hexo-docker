FROM ubuntu:latest

RUN sed -i "s#archive.ubuntu.com#mirrors.tuna.tsinghua.edu.cn#g;s#security.ubuntu.com#mirrors.tuna.tsinghua.edu.cn#g" /etc/apt/sources.list \
&& apt update \
&& apt install nodejs npm git openssh-client -y \
&& apt clean

RUN npm install yarn -g --registry=https://registry.npm.taobao.org/ \
&& yarn global add hexo-cli --registry https://registry.npm.taobao.org/ 

COPY autogen.sh /bin/autogen.sh

EXPOSE 4000

CMD [ "/bin/bash","/bin/autogen.sh" ]