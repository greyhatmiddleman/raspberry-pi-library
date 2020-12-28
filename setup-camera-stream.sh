#!/bin/bash



cat << EOF > /lib/systemd/system/mygphoto.service
# /lib/systemd/system/mygphoto.service
[Unit]
Description=gphoto2 live view service
After=multi-user.target 

[Service]
Type=simple
ExecStart=/usr/bin/sudo /bin/bash -lc 'gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0'
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF
