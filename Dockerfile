FROM ubuntu:latest

RUN sed -i "s#archive.ubuntu.com#mirrors.tuna.tsinghua.edu.cn#g;s#security.ubuntu.com#mirrors.tuna.tsinghua.edu.cn#g" /etc/apt/sources.list \
&& apt update \
&& apt install nodejs npm git openssh-client nginx -y \
&& apt clean \
&& printf "server {\n\tlisten 4000;\n\troot /var/www/html/hexo/public;\n\tindex index.html;\n\tlocation / {\n\t}\n}\n" > /etc/nginx/conf.d/hexo.conf

RUN npm install yarn -g --registry=https://registry.npm.taobao.org/ \
&& yarn config set registry https://registry.npm.taobao.org \
&& yarn global add hexo-cli 

COPY autogen.sh /bin/autogen.sh

EXPOSE 4000

CMD [ "/bin/bash","/bin/autogen.sh" ]