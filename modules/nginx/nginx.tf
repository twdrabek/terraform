terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

variable "PM_PASSWORD" {
  type        = string
  sensitive   = true
  description = "Container password"
}
variable "ID_RSA_PUB" {
  type      = string
  sensitive = true
}

resource "proxmox_lxc" "nginx" {
  target_node  = "pve"
  hostname     = "nginx"
  ostemplate   = "Mass:vztmpl/debian-12-turnkey-nginx-php-fastcgi_18.0-1_amd64.tar.gz"
  password     = var.PM_PASSWORD
  unprivileged = true
  start        = true
  onboot       = true

  // Memory in MB
  memory = 4096

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "Mass"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.10.0.6/24"
  }

  ssh_public_keys = var.ID_RSA_PUB

  tags = "Service Security Reverse_Proxy"
}