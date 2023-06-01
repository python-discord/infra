#!/bin/sh

# Start the rsync server and perform the transfer
rrsync -wo /etc/letsencrypt/live

# Reload NGINX
systemctl reload nginx
