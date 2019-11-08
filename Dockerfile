FROM centos:centos7

LABEL maintainer="Vipul Meehnia vipulmeehnia@gmail.com"

# Let the container know that there is no tty
ENV CENTOS_FRONTEND noninteractive
ENV NGINX_VERSION 1.16.1
ENV NODE_VERSION 12

# Install Basic Requirements
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
RUN yum -y install deltarpm
RUN yum -y install epel-release vim nano zip unzip gcc-c++ make \
    && yum -y update
RUN yum -y install python2-pip \
        python-setuptools \
        git \
        supervisor \
    && pip install wheel \
    && pip install supervisor-stdout

# Install Nginx
RUN yum -y install nginx-${NGINX_VERSION} \
    && rm -f /etc/nginx/conf.d/default.conf \
    && rm -f /etc/nginx/nginx.conf \
    && rm -Rf /usr/share/nginx/html

RUN curl -sL https://rpm.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && yum -y install nodejs

# Default configurations for Nginx and Node
RUN npm install -g forever

# Clean up
RUN rm -rf /tmp/pear \
    && yum clean all

# Supervisor config
ADD ./supervisord.conf /etc/supervisord.conf

# Override nginx's default config
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./default.conf /etc/nginx/conf.d/default.conf

# Override default nginx welcome page
COPY html /usr/share/nginx/html

RUN sed -i -e "s/<%= nginx_version %>/${NGINX_VERSION}/g" /usr/share/nginx/html/views/index.ejs

# Add Scripts
ADD ./start.sh /start.sh

EXPOSE 80

CMD ["/start.sh"]
