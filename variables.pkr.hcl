locals {
    output_directory = "builds/${formatdate("YYYY-MM-DD_hh-mm", timestamp())}"

    iso_url = "https://enterprise.proxmox.com/iso"
    iso_file = "proxmox-backup-server_4.2-1.iso"
    iso_checksum = "sha256:2fb299deac3929253712c9c3dfc9237edbe70af83c8848467616b771a1d5453e"
    iso_source = "./.cache"

    answer_filename = "answer.toml"
    cd_label = "cidata"
    unattended = {
      "/${local.answer_filename}" = templatefile("./${local.cd_label}/answer.toml.pkrtpl.hcl", { var = var })
    }
}

variable "ip" {
    type = string
}

variable "mask" {
    type = string
}

variable "gateway" {
    type = string
}

variable "hash_ssh_pass" {
    type = string
}

variable "public_key" {
    type = string
}

variable "private_key_file" {
    type = string
}