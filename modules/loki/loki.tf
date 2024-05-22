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
  default = "loki"
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
  loki_ip = trimsuffix(proxmox_lxc.loki.network[0].ip, "/24")
}

resource "proxmox_lxc" "loki" {
  target_node  = "pve"
  hostname     = var.HOSTNAME
  ostemplate   = "Mass:vztmpl/ubuntu-23.10-standard_23.10-1_amd64.tar.zst"
  password     = var.PM_PASSWORD
  unprivileged = true
  onboot       = true
  start        = true

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "Mass"
    size    = "128G"
  }

  // Memory in MB
  memory = 16384

  nameserver = "10.10.0.5"

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.10.0.11/24"
    gw     = "10.10.0.1"
  }

  ssh_public_keys = var.ID_RSA_PUB

  tags = "Security Monitoring Loki"
}

resource "ansible_host" "loki" {
  name   = local.loki_ip
  groups = ["Security", "Loki"]

  connection {
    type = "ssh"
    user = "root"
    host = this.name
  }

  depends_on = [
    proxmox_lxc.loki
  ]
}

resource "ansible_playbook" "loki_install_playbook" {
  playbook   = "./modules/loki/files/loki.playbook.yaml"
  name       = local.loki_ip
  replayable = true

  depends_on = [
    ansible_host.loki
  ]
}