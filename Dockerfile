# Cowrie Dockerfile by AV / MO 
#
# VERSION 17.06
FROM debian:jessie-slim
MAINTAINER AV / MO

# Include dist
ADD dist/ /root/dist/

# Setup apt
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && \
    apt-get upgrade -y && \

# Get and install dependencies & packages
    apt-get install -y supervisor python-pip libmpfr-dev libssl-dev libmpc-dev libffi-dev build-essential libpython-dev python2.7-minimal git python-mysqldb python-setuptools && \

# Install cowrie from git
    git clone https://github.com/micheloosterhof/cowrie.git /opt/cowrie && \
    cd /opt/cowrie && \
    pip install --upgrade cffi && \
    pip install -U -r requirements.txt && \

# Setup user, groups and configs
    addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot && \
    mkdir -p /var/run/cowrie/ /opt/cowrie/misc/ && \
    mv /root/dist/userdb.txt /opt/cowrie/misc/userdb.txt && \
    chown tpot:tpot /var/run/cowrie && \
    mv /root/dist/supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \
    mv /root/dist/cowrie.cfg /opt/cowrie/ && \

# Clean up
    rm -rf /root/* && \
    apt-get purge git python-pip python-setuptools libmpfr-dev libssl-dev libmpc-dev libffi-dev build-essential libpython-dev -y && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start supervisor
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
