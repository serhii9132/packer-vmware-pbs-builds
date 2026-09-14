#!/bin/bash

echo -e "n\np\n1\n\n\nw" | fdisk /dev/sdb
mkfs.ext4 /dev/sdb1
mkdir -p /storage

PART_UUID=$(blkid -s UUID -o value /dev/sdb1)
echo "UUID=${PART_UUID} /storage ext4 defaults 0 2" >> /etc/fstab

mount -a
chown backup:backup /storage
proxmox-backup-manager datastore create data /storage