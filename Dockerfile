# Cowrie Dockerfile by AV / MO 
#
# VERSION 16.10
FROM debian:jessie-slim
MAINTAINER AV / MO

# Include dist
ADD dist/ /root/dist/

# Setup apt
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && \
    apt-get upgrade -y && \

# Get and install dependencies & packages
    apt-get install -y supervisor python-pip libmpfr-dev libssl-dev libmpc-dev libffi-dev build-essential libpython-dev python2.7-minimal git mysql-server python-mysqldb python-setuptools \

# Setup ewsposter
                       python-lxml python-requests && \
    git clone https://github.com/rep/hpfeeds.git /opt/hpfeeds && \
      cd /opt/hpfeeds && \
      python setup.py install && \
    git clone https://github.com/vorband/ewsposter.git /opt/ewsposter && \
    mkdir -p /opt/ewsposter/spool /opt/ewsposter/log && \

# Install cowrie from git
    git clone https://github.com/micheloosterhof/cowrie.git /opt/cowrie && \
    cd /opt/cowrie && \
    pip install --upgrade cffi && \
    pip install -U -r requirements.txt && \

# Clean up apt
    apt-get remove git python-pip python-setuptools libmpfr-dev libssl-dev libmpc-dev libffi-dev build-essential libpython-dev -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

# Setup user, groups and configs
    addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot && \
    mkdir -p /var/run/cowrie/ /opt/cowrie/misc/ && \
    mv /root/dist/userdb.txt /opt/cowrie/misc/userdb.txt && \
    chown tpot:tpot /var/run/cowrie && \
    mv /root/dist/supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \
    mv /root/dist/cowrie.cfg /opt/cowrie/ && \

# Setup mysql
    sed -i 's#127.0.0.1#0.0.0.0#' /etc/mysql/my.cnf && \
    service mysql start && /usr/bin/mysqladmin -u root password "gr8p4$w0rd" && /usr/bin/mysql -u root -p"gr8p4$w0rd" < /root/dist/setup.sql && \

# Clean up dist
    rm -rf /root/dist

# Start supervisor
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
