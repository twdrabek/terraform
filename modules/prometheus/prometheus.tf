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
    default = "prometheus"
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
    prometheus_ip = trimsuffix(proxmox_lxc.prometheus.network[0].ip, "/24")
}

resource "proxmox_lxc" "prometheus" {
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
        ip     = "10.10.0.12/24"
        gw     = "10.10.0.1"
    }

    ssh_public_keys = "${var.ID_RSA_PUB}"

    tags = "Security Monitoring Prometheus"
}

resource "ansible_host" "prometheus" {
    name = local.prometheus_ip
    groups = [ "Security", "prometheus" ]
    variables = {
        HOSTNAME = var.HOSTNAME
    }

    depends_on = [ proxmox_lxc.prometheus ]
}

resource "ansible_playbook" "prometheus_install_playbook" {
    playbook   = "./modules/prometheus/files/prometheus.playbook.yaml"
    name       = local.prometheus_ip
    replayable = true
    verbosity = 6

    connection {
        type        = "ssh"
        user        = "root"
        host        = this.name
    }
    
    depends_on = [
        ansible_host.prometheus
        ]
}

