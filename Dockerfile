FROM ubuntu/bind9

RUN apt update \
  && apt install -y \
  bind9-doc \
  sudo \
  geoip-bin \
  nano \
  vim \
  curl \
  net-tools \
  iputils-ping \
  iputils-tracepath \
  traceroute \
  dnsutils

COPY config/named.conf /etc/bind/
COPY config/named.conf.local /etc/bind/
COPY config/db.safbiz.co.ke /etc/bind/
COPY config/db.41.203.208.rev /etc/bind/

# COPY ./config /etc/bind/
RUN chown -R bind:bind /etc/bind/
# RUN chown -R bind: /etc/bind; \
    # chown -R bind: /var/cache/bind;

USER bind
# Expose Ports
EXPOSE 53/tcp
EXPOSE 53/udp
EXPOSE 953/tcp

# Start the Name Service
# CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
