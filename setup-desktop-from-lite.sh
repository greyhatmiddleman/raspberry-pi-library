#!/bin/env bash

sudo apt install -y xserver-xorg && \
	sudo apt install -y raspberry-ui-mods && \
	sudo apt install -y lightdm

sudo apt install -y xrdp

systemctl show -p SubState --value xrdp

sudo sed -i 's/^allowed_user.*/allowed_users=anybody/' /etc/X11/Xwrapper.config

sudo adduser xrdp ssl-cert

echo "recommend to reboot at this point"
#sudo reboot
