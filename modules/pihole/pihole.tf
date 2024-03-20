terraform {
    required_providers {
        proxmox = {
            source = "Telmate/proxmox"
            version = "3.0.1-rc1"
        }
        pihole = {
            source = "ryanwholey/pihole"
            version = "0.2.0"
        }
    }
}

# provider "pihole" {
#     url      = "https://pihole.domain.com" # PIHOLE_URL
#     password = var.pihole_password         # PIHOLE_PASSWORD
# }

variable "PM_PASSWORD" {
    type = string
    sensitive = true
    description = "Container password"
}

resource "proxmox_lxc" "pihole" {
    target_node  = "pve"
    hostname     = "Pi-Hole"
    ostemplate   = "Mass:vztmpl/debian-12-turnkey-nginx-php-fastcgi_18.0-1_amd64.tar.gz"
    password     = var.PM_PASSWORD
    unprivileged = true
    start = true
    onboot = true

    // Memory in MB
    memory = 4096

  // Terraform will crash without rootfs defined
    rootfs {
        storage = "Mass"
        size    = "4G"
    }
    network {
        name   = "eth0"
        bridge = "vmbr0"
        ip     = "10.10.0.5/24"
        gw = "10.10.0.1"

    }
    tags = "Service Security"

    # provisioner "local-exec" {
    #     command = "pihole -up && pihole -g && pihole enable"
    # }
}
