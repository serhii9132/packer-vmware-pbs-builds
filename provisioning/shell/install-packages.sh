#!/bin/bash

rm -v /etc/apt/sources.list.d/pbs-enterprise.sources

apt-get update
apt-get upgrade -y
apt install -y open-vm-tools ansible