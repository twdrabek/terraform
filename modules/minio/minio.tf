terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.2.0"
    }
  }
}

variable "HOSTNAME" {
  type    = string
  default = "minio"
}
variable "PM_PASSWORD" {
  type      = string
  sensitive = true
}
variable "ID_RSA_PUB" {
  type      = string
  sensitive = true
}

locals {
  minio_ip = trimsuffix(proxmox_lxc.minio.network[0].ip, "/24")
}



resource "ansible_host" "minio" {
  name   = local.minio_ip
  groups = ["Security", "minio"]

  connection {
    type = "ssh"
    user = "root"
    host = this.name
  }

  depends_on = [
    proxmox_lxc.minio
  ]
}

resource "ansible_playbook" "minio_install_playbook" {
  playbook   = "./modules/minio/files/minio.playbook.yaml"
  name       = local.minio_ip
  replayable = true

  depends_on = [
    ansible_host.minio
  ]
}