FROM ubuntu:latest
# We base this on ubuntu

# Authenticated statically configured proxy

# Set env. replace right most column with values specific to your environment
ARG SQUID_CONF
ENV SQUID_CONF ${SQUID_CONF:-/etc/squid/squid.conf}
ARG SQUID_CACHEMGR_PASSWD
ENV SQUID_CACHEMGR_PASSWD ${SQUID_CACHEMGR_PASSWD:-secretpassword}
ARG SQUID_PROXY_PORT
ENV SQUID_PROXY_PORT ${SQUID_PROXY_PORT:-3128}
ARG SQUID_ICP_PORT
ENV SQUID_ICP_PORT ${SQUID_ICP_PORT:-3130}
ARG SQUID_USERNAME
ENV SQUID_USERNAME ${SQUID_USERNAME:-someuser}
ARG SQUID_PASSWORD 
ENV SQUID_PASSWORD ${SQUID_PASSWORD:-somepass}
ARG SQUID_HTCP_PORT
ENV SQUID_HTCP_PORT ${SQUID_HTCP_PORT:-4827}
ARG SQUID_PEER_NAME
ENV SQUID_PEER_NAME ${SQUID_PEER_NAME:-localhost}
ARG SQUID_EXTERNAL_LOGSERVER_IP
ENV SQUID_EXTERNAL_LOGSERVER_IP ${SQUID_EXTERNAL_LOGSERVER_IP:-127.0.0.1}
ARG SQUID_EMAIL_ADMIN 
ENV SQUID_EMAIL_ADMIN ${SQUID_EMAIL_ADMIN:-foo@bar.com}
ARG SQUID_EFFECTIVE_USER
ENV SQUID_EFFECTIVE_USER ${SQUID_EFFECTIVE_USER:-proxy}
ARG SQUID_EFFECTIVE_GROUP
ENV SQUID_EFFECTIVE_GROUP ${SQUID_EFFECTIVE_GROUP:-proxy}
ARG SQUID_ERROR_TEXT
ENV SQUID_ERROR_TEXT ${SQUID_EFFECTIVE_GROUP:-dansta_ubuntu_squid_proxy}
ARG SQUID_VISIBLE_HOSTNAME
ENV SQUID_VISIBLE_HOSTNAME ${SQUID_VISIBLE_HOSTNAME:-pomperipossa.localdomain}
ARG SQUID_EMAIL_FROMADDRESS
ENV SQUID_EMAIL_FROMADDRESS ${SQUID_EMAIL_FROMADDRESS:-squid@localhost.localdomain}
LABEL maintainer=dansta

HEALTHCHECK --interval=1m --timeout=3s CMD /usr/local/bin/squid -k check || exit 1

# Update and install packages
RUN apt-get update
RUN apt-get install -y squid
RUN apt-get install -y python3
RUN apt-get install -y apache2-utils

ADD files/squid.conf ${SQUID_CONF} 
ADD files/replace.py /usr/local/bin/replace_conf
ADD files/hosts /etc/hosts
RUN chmod +rx /usr/local/bin/replace_conf
RUN /usr/local/bin/replace_conf ${SQUID_CONF} SQUID
RUN rm -f /usr/local/bin/replace_conf

# Setup username and password
RUN mkdir -p /etc/squid3/
RUN touch /etc/squid3/users
RUN chown ${SQUID_EFFECTIVE_USER}:${SQUID_EFFECTIVE_GROUP} /etc/squid3/ /etc/squid3/users
RUN chmod g+rwx /etc/squid3/ /etc/squid3/users
RUN htpasswd -c -db /etc/squid3/users ${SQUID_USERNAME} ${SQUID_PASSWORD}

# Add wrapper for execution
ADD files/wrapper.sh /usr/local/bin/wrapper
RUN chmod +rx /usr/local/bin/wrapper

# Mount volumes to keep store and logs away from the thin layer overlay
# This is important for performance and memory footprint
# And dont forget to use --mount on the service otherwise it is going to
# recreate the store on every upstart
VOLUME /var/log/
VOLUME /var/spool/squid/
# Rotate the logs every 2nd hour
RUN echo "* */2 * * * /usr/local/squid/bin/squid -k rotate" >> /var/spool/cron/root

# Remove this line if you want to be able to rerun replace_conf
# to enable runtime environment variables being read into the application
# Otherwise we do not need this package for runtime activities
# Replace_conf might become a standalone binary in the future
RUN apt-get remove -y python3
RUN apt-get remove -y apache2-utils
RUN apt-get autoremove -y
# Document port usage for docker in case you are going to use it as a service
EXPOSE ${SQUID_PROXY_PORT}/tcp
EXPOSE ${SQUID_HTCP_PORT}/tcp
EXPOSE ${SQUID_ICP_PORT}/tcp
EXPOSE 4002:4002/tcp
EXPOSE 4003:4003/tcp
# Test squid for build
CMD /usr/local/bin/wrapper
