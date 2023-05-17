from centos:latest

MAINTAINER Anoop A K <anoop@codecg.com> 

RUN useradd -d /var/lib/render -g render -c 'Afanasy Render User' render 

RUN yum makecache

# Install postgresql-libs
RUN yum install postgresql-libs wget tar -y

# Copy afanasy RPMs to /tmp
WORKDIR /tmp
RUN wget --no-check-certificate https://sourceforge.net/projects/cgru/files/2.3.1/cgru.2.3.1.CentOS-7_x86_64.tar.gz

# Extract the archive to /tmp
RUN tar xfv cgru.2.3.1.CentOS-7_x86_64.tar.gz -C /tmp/

# Install Dependencies
RUN yum install postgresql-libs -y

# Install afanasy-render
RUN yum install cgru-common-2.3.1-0.x86_64.rpm -y
RUN yum install afanasy-common-2.3.1-0.x86_64.rpm -y
RUN yum install afanasy-render-2.3.1-0.x86_64.rpm -y

# Set CGRU environment variables
ENV PATH /opt/cgru/afanasy/bin:$PATH
ENV CGRU_LOCATION /opt/cgru
ENV AF_ROOT /opt/cgru/afanasy
ENV PYTHONPATH /opt/cgru/lib/python:/opt/cgru/afanasy/python:$PYTHONPATH
ENV AF_SERVERNAME afanasyServer

# Copy the default configuration file to AF_ROOT
ADD config_default.json /opt/cgru/afanasy/config_default.json

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]

EXPOSE 51001

CMD ["afrender"]
