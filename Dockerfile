# OSはCentOSi7
FROM centos:7
LABEL maintainer "DeepResearch <fukazawa@deepresearch-inc.com>"

#開発ツールのインストール
RUN yum -y update && yum clean all
RUN yum -y install yum-utils && yum clean all
RUN yum -y groupinstall development gcc && yum clean all

#Pythonのインストール
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN yum install -y python36u python36u-libs python36u-devel python36u-pip

#Nginx
RUN yum install -y http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN yum install -y --enablerepo=nginx nginx

#Python仮想環境作成
WORKDIR /usr/share/nginx
RUN python3.6 -m venv site
ENV VIRTUAL_ENV=/usr/share/nginx/site
ENV PATH=/usr/share/nginx/site/bin:$PATH

#アプリケーションサーバ、開発者用ユーザ追加
RUN groupadd apgroup
RUN useradd apuser -g apgroup

#Django用ディレクトリ作成
WORKDIR /usr/share/nginx/site
RUN mkdir webapp
RUN chown -R apuser:apgroup /usr/share/nginx/site/webapp
RUN chmod -R 777 /usr/share/nginx/site/webapp

#pip設定
WORKDIR /usr/share/nginx/site/webapp
ADD requirements.txt .
RUN pip install --upgrade setuptools
RUN pip install -r requirements.txt

#djangoプロジェクトのコピー
WORKDIR /usr/share/nginx/site/webapp
ADD uwsgi.ini .
ADD uwsgi-webapp.service .
ADD DrProject.zip .
RUN unzip DrProject.zip
RUN chown -R apuser:apgroup /usr/share/nginx/site/webapp
RUN chmod -R 777 /usr/share/nginx/site/webapp

#NGINX
WORKDIR /etc/nginx/conf.d
ADD backend.conf .
RUN mv default.conf default.back

EXPOSE 80

#uWSGI
ENV DJANGO_SETTINGS_MODULE=DrProject.settings
WORKDIR /usr/share/nginx/site/webapp
ADD start.sh .
RUN chmod -R 777 /usr/share/nginx/site/webapp/start.sh

#ログ設定
WORKDIR /var/log
RUN mkdir django
RUN chmod -R 777 /var/log/django
WORKDIR /var/log/django
RUN touch django.log
RUN chmod 777 /var/log/django/django.log

#DB設定
RUN yum -y install mysql && yum clean all
RUN yum -y install MySQL-python && yum clean all

CMD ["/usr/share/nginx/site/webapp/start.sh"]
