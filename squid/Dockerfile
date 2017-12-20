FROM ubuntu:latest
# We base this on ubuntu

# Authenticated statically configured proxy
# (no runtime env support)

# Set env. replace right most column with values specific to your environment
ENV SQUID_CONF '/etc/squid/squid.conf'
ENV SQUID_PROXY_PORT 3128
ENV SQUID_USERNAME username
ENV SQUID_PASSWORD password
ENV SQUID_ICP_PORT 3130
ENV SQUID_PEER_NAME squidpeer
ENV SQUID_EXTERNAL_LOGSERVER_IP localhost
ENV SQUID_EXTERNAL_LOGSERVER_PORT 514
ENV SQUID_EMAIL_ADMIN foo@bar.com
ENV SQUID_EMAIL_FROMADDRESS squid@hostname.local
ENV SQUID_EFFECTIVE_USER proxy
ENV SQUID_EFFECTIVE_GROUP proxy 
ENV SQUID_ERROR_TEXT dansta_ubuntu_squid_proxy
LABEL maintainer=dansta

# Change to some webserver that you know is stable. mine isnt which is why per default this is commented out
#HEALTHCHECK --interval=15m --timeout=3s CMD curl -x 127.0.0.1:3128 -f http://www.kvantmekanik.se || exit 1

# Update and install packages
RUN apt-get update
RUN apt-get install -y squid
RUN apt-get install -y rsyslog
RUN apt-get install -y python3
ADD files/etc/squid.conf ${SQUID_CONF} 
ADD files/replace.py /usr/local/bin/replace_conf
RUN chmod +rx /usr/local/bin/replace_conf
RUN /usr/local/bin/replace_conf ${SQUID_CONF} SQUID
RUN cat ${SQUID_CONF}

# Remove this line if you want to be able to rerun replace_conf
# to enable runtime environment variables being read into the application
# Otherwise we do not need this package for runtime activities
# Replace_conf might become a standalone binary in the future
RUN apt-get remove -y python3

# Document port usage for docker in case you are going to use it as a service
EXPOSE ${SQUID_PROXY_PORT}/tcp
EXPOSE ${SQUID_ICP_PORT}/tcp

# Logging for debug. logging should be handled by your support team
# might possibly indicate a working container if you build@home
RUN service rsyslog start

# Test squid for build, run in foreground
CMD /usr/sbin/squid -k parse
CMD /usr/sbin/squid -NCd1
