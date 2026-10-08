#!/bin/bash

rm -rf /root/.ansible
apt remove --purge -y ansible
apt autoremove -y