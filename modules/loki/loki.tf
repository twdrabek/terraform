terraform {
    required_providers {
        proxmox = {
            source = "Telmate/proxmox"
            version = "3.0.1-rc1"
        }
        ansible = {
            source = "ansible/ansible"
            version = "1.2.0"
        }
    }
}

variable "HOSTNAME" {
    type = string
    default = "loki"
}
variable "PM_PASSWORD" {
    type = string
    sensitive = true
}
variable "ID_RSA_PUB" {
    type = string
    sensitive = true
}
variable "PLAYBOOK" {
    type = string
    default = "./loki/files/playbook.yaml"
}

resource "proxmox_lxc" "loki" {
    target_node  = "pve"
    hostname     = var.HOSTNAME
    ostemplate   = "Mass:vztmpl/ubuntu-23.10-standard_23.10-1_amd64.tar.zst"
    password     = var.PM_PASSWORD
    unprivileged = true
    onboot = true
    start = true

    // Terraform will crash without rootfs defined
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
        ip     = "10.10.0.11/24"
        gw     = "10.10.0.1"
    }

    ssh_public_keys = "${var.ID_RSA_PUB}"

    tags = "Security Monitoring Loki"
}

resource "ansible_host" "loki" {
    name = trimsuffix(proxmox_lxc.loki.network[0].ip, "/24")
    groups = [ "Security", "Loki" ]
    variables = {
        HOSTNAME = var.HOSTNAME
    }

    depends_on = [ proxmox_lxc.loki ]
}

resource "ansible_playbook" "loki_playbook" {
    playbook   = "/home/h4ndl3/Projects/Terraform/modules/loki/files/playbook.yaml"
    name       = trimsuffix(proxmox_lxc.loki.network[0].ip, "/24")
    replayable = true

    connection {
        type        = "ssh"
        user        = "root"
        host        = trimsuffix(proxmox_lxc.loki.network[0].ip, "/24")
    }
    
    depends_on = [ proxmox_lxc.loki ]
}
