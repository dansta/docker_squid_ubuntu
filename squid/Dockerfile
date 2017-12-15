FROM ubuntu:latest
# we base this on ubuntu

# authenticated proxy

# set env. replace right most column with values specific to your environment
ENV SQUID_CONF '/etc/squid/squid.conf'
ENV SQUID_PROXY_PORT 3128
ENV SQUID_USERNAME username
ENV SQUID_PASSWORD password
ENV SQUID_ICP_PORT 3130
ENV SQUID_PEER_NAME squidpeer
ENV SQUID_EXTERNAL_LOGSERVER_IP somehost 
ENV SQUID_EXTERNAL_LOGSERVER_PORT 123
ENV SQUID_EMAIL_ADMIN foo@bar.com
ENV SQUID_EMAIL_FROMADDRESS squid@hostname.local
ENV SQUID_EFFECTIVE_USER proxy
ENV SQUID_EFFECTIVE_GROUP proxy 
ENV SQUID_ERROR_TEXT dansta_proxy
LABEL maintainer=dansta

# change to some webserver that you know is stable. mine isnt which is why per default this is commented out
#HEALTHCHECK --interval=15m --timeout=3s CMD curl -x 127.0.0.1:3128 -f http://www.kvantmekanik.se || exit 1

# add proxies, in case you are rebuilding on a system behind a proxy
#ADD files/apt.conf /etc/apt/apt.conf

# update and install packages
RUN apt-get update
RUN apt-get install -y squid
RUN apt-get install -y rsyslog
ADD files/etc/squid.conf ${SQUID_CONF} 
ADD files/replace_conf.sh /usr/local/bin/replace_conf
ADD files/value.awk /usr/local/bin/value.awk
ADD files/key.awk /usr/local/bin/key.awk
RUN chmod +rx /usr/local/bin/replace_conf
RUN /usr/local/bin/replace_conf ${SQUID_CONF} SQUID
RUN cat ${SQUID_CONF}

# document port usage for docker in case you are going to use it as a service
EXPOSE ${SQUID_PROXY_PORT}/tcp
EXPOSE ${SQUID_ICP_PORT}/tcp

# logging for debug. logging should be handled by your support team
# might possibly indicate a working container if you build@home
RUN service rsyslog start

# test squid for build, run in foreground
CMD /usr/sbin/squid -k parse
CMD /usr/sbin/squid -NCd1
