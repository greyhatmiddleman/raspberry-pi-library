#!/bin/bash

cat << EOF > /usr/local/bin/screen-off.sh
#!/bin/bash

sudo sh -c 'echo "0" > /sys/class/backlight/soc\:backlight/brightness'
EOF

chmod +x /usr/local/bin/screen-off.sh


cat << EOF > /etc/systemd/system/screen-off.service
[Unit]
Description=TFT Screen Off
Conflicts=reboot.target
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/true
ExecStop=/usr/local/bin/screen-off.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF


systemctl enable --now screen-off

