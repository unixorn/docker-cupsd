# docker-cupsd

`cupsd` in a docker container.

Based on buster-slim. Includes cupsd, every printer driver I could think of.

Passwords are print/print

## Run the server

Start `cupsd` with:
```
sudo docker run -d --restart unless-stopped \
  -p 631:631 \
  --privileged \
  -v /var/run/dbus:/var/run/dbus \
  -v /dev/bus/usb:/dev/bus/usb \
  -v $(pwd)/printers.conf:/etc/cups/printers.conf \
  unixorn/cupsd
```

Mmounting `printers.conf` into the container keeps you from losing your printer configuration when you upgrade the container later.

## Add printers to server

1. Connect to http://hostname:631
2. Adminstration -> Printers -> Add Printer

## Add the printer to your Mac

1. System Preferences -> Printers
2. Click on the +
3. Click the center sphere icon
4. Put the IP (or better, DNS name) of your server in the Address field
5. Select Internet Printing Protocol in the Protocol dropdown
6. Put printers/YOURPRINTERNAME in the queue field.
