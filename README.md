Proxmox Backup Server Vagrant image for VMware Workstation Pro

Template parameters:
```sh
OS version: Proxmox backup server 4.2-1
Cores: 2
Socket: 1
RAM: 6Gb
Main disk size: 25 Gb
Additional disk size: 350 Gb
```

The “data” storage is mounted at the path /storage.

### Usage

1. Create a .env file in the root of the project with the following content:
```sh
PKR_VAR_hash_ssh_pass='$6$aJcAVcNj.....'                # Use: mkpasswd -m sha-512
PKR_VAR_public_key='ssh-ed25519 AAAAC...'  
PKR_VAR_private_key_file='D://.ssh//keys//key.pem'

PKR_VAR_ip='192.168.0.10'
PKR_VAR_mask='24'
PKR_VAR_gateway='192.168.0.1'
```
2. Run build:
```sh
make pbs
```
