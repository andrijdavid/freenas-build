#!/bin/sh
#
# EC2 disk provision script
#

DISK="$1"
if [ ! -e "/dev/${DISK}" ] ; then
	echo "Missing device /dev/${DISK}"
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

gpart add -t freebsd-ufs ${DISK}
if [ $? -ne 0 ] ; then
	exit 1
fi

newfs -U -J /dev/${DISK}p2
if [ $? -ne 0 ] ; then
	exit 1
fi

mount /dev/${DISK}p2 vm-mnt/
if [ $? -ne 0 ] ; then
	exit 1
fi

# Disk provision done
