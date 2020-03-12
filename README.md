# motd
Motd Banner Script Ubuntu

place this file as executable (chmod +x) in /etc/update-motd.d
and remove "10-help-text".



It will give a colored system status overview.
Including network settings, mem and disk overview.

It generates colored output based on system state. (green or red)

This script could also be useful in combination with conky.

Make sure you install column from bsdmainutils package.
(apt install bsdmainutils)

## fail2ban and uwf are required! 




![alt text](https://github.com/schroeert/motd/blob/master/motd.png)

