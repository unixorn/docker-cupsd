FROM debian:bullseye-slim
LABEL maintainer="Joe Block <jpb@unixorn.net>"
LABEL description="Cupsd on top of debian-slim"

# Install Packages (basic tools, cups, fonts, HP drivers, laundry list drivers)
RUN apt-get update \
&& apt-get install -y --no-install-recommends apt-utils ca-certificates \
&& update-ca-certificates \
&& apt autoremove -y \
&& apt-get install -y \
  cups \
  cups-bsd \
  cups-client \
  cups-filters \
  foomatic-db-compressed-ppds \
  gsfonts \
  gutenprint-locales \
  hp-ppd \
  hpijs-ppds \
  hplip \
  magicfilter \
  openprinting-ppds \
  printer-driver-all \
  printer-driver-brlaser \
  printer-driver-c2050 \
  printer-driver-c2esp \
  printer-driver-cjet \
  printer-driver-cups-pdf \
  printer-driver-dymo \
  printer-driver-escpr \
  printer-driver-foo2zjs \
  printer-driver-fujixerox \
  printer-driver-gutenprint \
  printer-driver-hpcups \
  printer-driver-hpijs \
  printer-driver-m2300w \
  printer-driver-min12xxw \
  printer-driver-pnm2ppa \
  printer-driver-postscript-hp \
  printer-driver-ptouch \
  printer-driver-pxljr \
  printer-driver-sag-gdi \
  printer-driver-splix \
&& apt-get install -y --no-install-recommends \
  binutils \
  psutils \
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

# Fix Bad Request error by adding ServerAlias * to cupsd.conf
RUN cp /etc/cups/cupsd.conf /etc/cups/fixit && \
  sed 's/Port 631/Port 631\nServerAlias \*/' < /etc/cups/fixit > /etc/cups/cupsd.conf && \
  rm -f /etc/cups/fixit

# Configure the services to be reachable
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid)

# Patch the default configuration file to only enable encryption if requested
RUN sed -e '0,/^</s//DefaultEncryption IfRequested\n&/' -i /etc/cups/cupsd.conf

# Default shell
CMD ["/usr/sbin/cupsd", "-f"]
