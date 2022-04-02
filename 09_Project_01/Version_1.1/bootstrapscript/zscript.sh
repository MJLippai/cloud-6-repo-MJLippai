#!/bin/sh
sudo su
apt-get update
apt-get install apache2 -y
ufw allow 'Apache'
systemctl enable apache2
systemctl restart apache2