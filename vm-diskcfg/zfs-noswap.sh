#!/bin/sh
#
# EC2 disk provision script
#

`dirname $0`/zfs-noswap-common.sh "$@"

DISK="$1"
POOL="$2"
ONDISKPOOL="$3"

zfs set compression=on ${POOL}
zfs create -o canmount=off ${POOL}/ROOT
zfs create -o canmount=on -o mountpoint=/ ${POOL}/ROOT/initial
zfs create -o canmount=on -o mountpoint=/root ${POOL}/root
zfs create -o canmount=on -o mountpoint=/tmp ${POOL}/tmp
zfs create -o canmount=off ${POOL}/usr
zfs create -o canmount=on -o mountpoint=/usr/home ${POOL}/usr/home
zfs create -o canmount=on -o mountpoint=/usr/jails ${POOL}/usr/jails
zfs create -o canmount=on -o mountpoint=/usr/obj ${POOL}/usr/obj
zfs create -o canmount=on -o mountpoint=/usr/ports ${POOL}/usr/ports
zfs create -o canmount=on -o mountpoint=/usr/src ${POOL}/usr/src
zfs create -o canmount=off ${POOL}/var
zfs create -o canmount=on -o mountpoint=/var/audit ${POOL}/var/audit
zfs create -o canmount=on -o mountpoint=/var/mail ${POOL}/var/mail
zfs create -o canmount=on -o mountpoint=/var/tmp ${POOL}/var/tmp
zpool set bootfs=${POOL}/ROOT/initial ${POOL}

# Disk provision done
