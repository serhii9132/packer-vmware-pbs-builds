#!/bin/bash

apt clean
apt autoremove

dd if=/dev/zero of=/zerofile bs=1M status=progress conv=fdatasync
rm /zerofile