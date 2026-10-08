packer {
  required_plugins {
    vmware = {
      source = "github.com/hashicorp/vmware"
      version = "2.1.1"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "1.1.7"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "1.1.4"
    }
  }
}

source "vmware-iso" "pbs" {
  version                        = 21
  firmware                       = "bios"
  headless                       = true
  skip_export                    = true
  guest_os_type                  = "debian13-64"
  vm_name                        = "pbs"
  vhv_enabled                    = true

  cpus                           = 2
  cores                          = 2
  memory                         = 6144
  disk_size                      = 25000
  disk_additional_size           = [350000]
  disk_type_id                   = 0
  disk_adapter_type              = "scsi"
  network_adapter_type           = "vmxnet3"

  cdrom_adapter_type             = "sata"
  iso_url                        = "${local.iso_url}/${local.iso_file}"
  iso_checksum                   = local.iso_checksum
  iso_target_path                = abspath("${local.iso_source}/${local.iso_file}")

  output_directory               = abspath("${local.output_directory}")

  communicator                   = "ssh"

  cd_label                      = local.cd_label
  cd_content                    = local.unattended

  vnc_bind_address               = "127.0.0.1"
  vnc_port_min                   = 5960
  vnc_port_max                   = 5960
  vnc_disable_password           = false
  
  ssh_host                       = var.ip
  ssh_username                   = "root"
  ssh_private_key_file           = var.private_key_file
  ssh_timeout                    = "30m"

  boot_wait                      = "10s"
  boot_command = [
      "<down><down><down><enter><wait5s>",
      "<down><down><down><down><down><enter>",
      "<wait45s>",
      "proxmox-fetch-answer partition ${local.cd_label} > /run/automatic-installer-answers<enter><wait>exit<enter>",
      "<wait3m>"
  ]
  shutdown_command               = "poweroff"
}

build {
  sources = ["sources.vmware-iso.pbs"]

  provisioner "shell" {
    scripts = [
      "./provisioning/shell/install-packages.sh"
    ]
  }

  provisioner "ansible-local" {
    playbook_file   = "./provisioning/ansible/playbook.yaml"
    inventory_file  = "./provisioning/ansible/hosts.yaml"
    host_vars       = "./provisioning/ansible/host_vars"
    galaxy_file     = "./provisioning/ansible/requirements.yaml"
    extra_arguments = [ "-vv" ]
    command         = "ANSIBLE_STDOUT_CALLBACK=yaml ansible-playbook"
  }

  provisioner "shell" {
    scripts = [
      "./provisioning/shell/remove-ansible.sh",
      "./provisioning/shell/add-storage.sh",
      "./provisioning/shell/zero-space.sh"
    ]
  }

  post-processor "vagrant" {
    keep_input_artifact  = true
    output               = "${local.output_directory}/pbs.box"
  }
}