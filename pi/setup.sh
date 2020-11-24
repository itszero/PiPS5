#!/bin/sh

echo "-> Make a 4G image for the drive"
fallocate -l 4G drive.img
mkfs.vfat drive.img -F 32 -n "PiPS5"

echo "-> Copy supervisord conf"
cp supervisord.conf /etc/supervisor/conf.d/pips5.conf

