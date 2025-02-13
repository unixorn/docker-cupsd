# docker-cupsd
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Run the server](#run-the-server)
- [Add printers to server](#add-printers-to-server)
- [Add the printer to your Mac](#add-the-printer-to-your-mac)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


`cupsd` in a docker container.

Based on debian:bullseye-slim. Includes [cupsd](https://cups.org) along with every printer driver I could think of.

Admin user & passwords default to **print** / **print**

## Run the server

Start `cupsd` with:

```sh
sudo docker run -d --restart unless-stopped \
  -p 631:631 \
  --privileged \
  -v /var/run/dbus:/var/run/dbus \
  -v /dev/bus/usb:/dev/bus/usb \
  -v $(pwd)/printers.conf:/etc/cups/printers.conf \
  unixorn/cupsd
```

or use `docker-compose up` with the following `docker-compose.yaml`:

```yaml
version: '3.9'
services:
  cupsd:
    image: unixorn/cupsd
    volumes:
      - './printers.conf:/etc/cups/printers.conf'
      - '/dev/bus/usb:/dev/bus/usb'
      - '/var/run/dbus:/var/run/dbus'
      - /etc/hostname:/etc/hostname:ro
      - /etc/localtime:/etc/localtime:ro
      - /etc/machine-id:/etc/machine-id:ro
      - /etc/timezone:/etc/timezone:ro
    privileged: true
    ports:
      - '631:631'
    restart: unless-stopped
```

Mounting `printers.conf` into the container keeps you from losing your printer configuration when you upgrade the container later.

## Add printers to server

1. Connect to `http://cupsd-hostname:631`
2. **Adminstration** -> **Printers** -> **Add Printer**

## Add the printer to your Mac

1. **System Preferences** -> **Printers**
2. Click on the **+**
3. Click the center sphere icon
4. Put the IP (or better, DNS name) of your server in the Address field
5. Select `Internet Printing Protocol` in the Protocol dropdown
6. Put `printers/YOURPRINTERNAME` in the queue field.

I use this to integrate with [Home Assistant](https://www.home-assistant.io/). I blogged how I use Home Assistant to automagically turn on my HP4050N printer when there are print jobs and turn it back off when the jobs are complete [here](https://unixorn.github.io/post/home-assistant-printer-power-management/), but it'll work with any printer.