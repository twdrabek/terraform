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
  default = "grafana"
}
variable "ID_RSA_PUB" {
  type      = string
  sensitive = true
}
variable "PM_PASSWORD" {
  type      = string
  sensitive = true
}
variable "GRAFANA_USERNAME" {
  type = string
}
variable "GRAFANA_PASSWORD" {
  type      = string
  sensitive = true
}
locals {
  grafana_ip = trimsuffix(proxmox_lxc.grafana.network[0].ip, "/24")
}

resource "proxmox_lxc" "grafana" {
  target_node  = "pve"
  hostname     = var.HOSTNAME
  ostemplate   = "Mass:vztmpl/ubuntu-23.10-standard_23.10-1_amd64.tar.zst"
  password     = var.PM_PASSWORD
  unprivileged = true
  onboot       = true
  start        = true

  rootfs {
    storage = "Mass"
    size    = "8G"
  }

  // Memory in MB
  memory = 16384

  nameserver = "10.10.0.5"

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.10.0.10/24"
    gw     = "10.10.0.1"
  }

  ssh_public_keys = var.ID_RSA_PUB

  tags = "Security Monitoring Grafana"
}

resource "ansible_host" "grafana" {
  name   = local.grafana_ip
  groups = ["Security", "Grafana"]

  connection {
    type = "ssh"
    user = "root"
    host = this.name
  }

  depends_on = [
    proxmox_lxc.grafana
  ]
}

resource "ansible_playbook" "grafana_config_playbook" {
  playbook   = "/home/h4ndl3/Projects/Terraform/modules/grafana/files/grafana.config.playbook.yaml"    #grafana.config.playbook.yaml
  name       = ansible_host.grafana.name
  replayable = true

  extra_vars = {
    GRAFANA_USERNAME = var.GRAFANA_USERNAME
    GRAFANA_PASSWORD = var.GRAFANA_PASSWORD
    GRAFANA_URL      = "http://${local.grafana_ip}:3000/"
  }

  depends_on = [
    ansible_host.grafana
  ]
}