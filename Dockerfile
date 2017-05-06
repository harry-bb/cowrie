# Cowrie Dockerfile by AV / MO 
#
# VERSION 17.06
FROM alpine
MAINTAINER MO

# Include dist
ADD dist/ /root/dist/

# Get and install dependencies & packages
RUN apk -U add git procps py-pip mpfr-dev openssl-dev mpc1-dev libffi-dev build-base python python-dev py-mysqldb py-setuptools gmp-dev && \

# Setup user
    addgroup -g 2000 tpot && \
    adduser -S -s /bin/bash -u 2000 -D -g 2000 tpot && \

# Install cowrie from git
    git clone https://github.com/micheloosterhof/cowrie.git /home/tpot/cowrie/ && \
    cd /home/tpot/cowrie && \
    pip install --no-cache-dir --upgrade cffi && \
    pip install --no-cache-dir -U -r requirements.txt && \

# Setup user, groups and configs
    cp /root/dist/cowrie.cfg /home/tpot/cowrie/cowrie.cfg && \
    cp /root/dist/userdb.txt /home/tpot/cowrie/data/userdb.txt && \
    chown tpot:tpot -R /home/tpot/* && \

# Clean up
    rm -rf /root/* && \
    apk del git py-pip mpfr-dev mpc1-dev libffi-dev build-base py-mysqldb gmp-dev python-dev && \
    rm -rf /var/cache/apk/*

# Start cowrie
ENV PYTHONPATH /home/tpot/cowrie
WORKDIR /home/tpot/cowrie
USER tpot
CMD ["/usr/bin/twistd", "--nodaemon", "-y", "cowrie.tac", "--pidfile", "var/run/cowrie.pid", "cowrie"]
