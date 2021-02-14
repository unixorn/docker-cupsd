FROM debian:buster-slim
LABEL maintainer="Joe Block <jpb@unixorn.net>"
LABEL description="Cupsd on top of debian-slim"

# Install Packages (basic tools, cups, basic drivers, HP drivers)
RUN apt-get update \
&& apt-get install -y apt-utils ca-certificates --no-install-recommends \
&& update-ca-certificates \
&& apt-get install -y \
  cups \
  cups-bsd \
  cups-client \
  cups-filters \
  foomatic-db-compressed-ppds \
  hp-ppd \
  hpijs-ppds \
  hplip \
  openprinting-ppds \
  printer-driver-all \
  printer-driver-cups-pdf \
  smbclient \
  sudo \
  whois \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/*

# Add user and disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Configure the services to be reachable
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid)

# Patch the default configuration file to only enable encryption if requested
RUN sed -e '0,/^</s//DefaultEncryption IfRequested\n&/' -i /etc/cups/cupsd.conf

# Default shell
CMD ["/usr/sbin/cupsd", "-f"]
