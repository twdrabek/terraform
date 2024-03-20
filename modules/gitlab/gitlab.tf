terraform {
    required_providers {
        proxmox = {
        source = "Telmate/proxmox"
        version = "3.0.1-rc1"
        }
    }
}

variable "PM_CPASS" {
    type = string
    sensitive = true
    description = "Container password"
}

resource "proxmox_lxc" "gitlab" {
    target_node  = "pve"
    hostname     = "Gitlab"
    ostemplate   = "Mass:vztmpl/debian-11-turnkey-gitlab_17.1-1_amd64.tar.gz"
    password     = var.PM_CPASS
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

    tags = "Service"
}