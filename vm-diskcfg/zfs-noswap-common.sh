#!/bin/sh
#
# EC2 disk provision script
#

DISK="$1"
POOL="$2"
ONDISKPOOL="$3"
if [ ! -e "/dev/${DISK}" ] ; then
	echo "Missing device /dev/${DISK}"
fi

if [ -z "$POOL" ] ; then
	echo "Missing POOL argument"
fi

if [ ! -d "vm-mnt" ] ; then
	mkdir vm-mnt
fi

gpart create -s gpt -f active ${DISK}
if [ $? -ne 0 ] ; then
	exit 1
fi

gpart add -t freebsd-boot -s 512 ${DISK}
if [ $? -ne 0 ] ; then
	exit 1
fi

gpart add -t freebsd-zfs ${DISK}
if [ $? -ne 0 ] ; then
	exit 1
fi

zpool create  -t ${POOL} -m none -R $(pwd)/vm-mnt ${ONDISKPOOL} ${DISK}p2
if [ $? -ne 0 ] ; then
	exit 1
fi
