terraform {
    required_providers {
        proxmox = {
        source = "Telmate/proxmox"
        version = "3.0.1-rc1"
        }
    }
}

variable "PM_PASSWORD" {
    type = string
    sensitive = true
    description = "Container password"
}
variable "ID_RSA_PUB" {
    type = string
    sensitive = true
}

resource "proxmox_lxc" "gitlab" {
    target_node  = "pve"
    hostname     = "gitlab"
    ostemplate   = "Mass:vztmpl/debian-11-turnkey-gitlab_17.1-1_amd64.tar.gz"
    password     = var.PM_PASSWORD
    unprivileged = true
    start = true
    onboot = true

    // Memory in MB
    memory = 8192

  // Terraform will crash without rootfs defined
    rootfs {
        storage = "Mass"
        size    = "32G"
    }

    network {
        name   = "eth0"
        bridge = "vmbr0"
        ip     = "dhcp"
    }

    ssh_public_keys = "${var.ID_RSA_PUB}"

    tags = "Service"
}