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
    default = "tempo"
}
variable "PM_PASSWORD" {
    type = string
    sensitive = true
}
variable "ID_RSA_PUB" {
    type = string
    sensitive = true
}

locals {
    tempo_ip = trimsuffix(proxmox_lxc.tempo.network[0].ip, "/24")
}

resource "proxmox_lxc" "tempo" {
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
        size    = "128G"
    }

    // Memory in MB
    memory = 16384

    nameserver = "10.10.0.5"

    network {
        name   = "eth0"
        bridge = "vmbr0"
        ip     = "10.10.0.14/24"
        gw     = "10.10.0.1"
    }

    ssh_public_keys = "${var.ID_RSA_PUB}"

    tags = "Security Monitoring tempo"
}

resource "ansible_host" "tempo" {
    name = local.tempo_ip
    groups = [ "Security", "tempo", "ubuntu" ]
    variables = {
        HOSTNAME = var.HOSTNAME
    }

    depends_on = [ proxmox_lxc.tempo ]
}

resource "ansible_playbook" "tempo_playbook_install" {
    playbook   = "./modules/tempo/files/tempo.playbook.yaml"
    name       = local.tempo_ip
    replayable = true

    connection {
        type        = "ssh"
        user        = "root"
        host        = this.name
    }
    
    depends_on = [ proxmox_lxc.tempo ]
}
