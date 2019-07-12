#!/bin/sh
#
# EC2 disk provision script
#

`dirname $0`/zfs-noswap-common.sh "$@"

DISK="$1"
POOL="$2"
ONDISKPOOL="$3"

zfs create -o canmount=off ${POOL}/ROOT
zfs create -o canmount=on -o mountpoint=/ ${POOL}/ROOT/default
zpool set bootfs=${POOL}/ROOT/default ${POOL}

touch vm-mnt/.ec2

# Disk provision done
