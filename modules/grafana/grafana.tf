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
    default = "grafana"
}
variable "ID_RSA_PUB" {
    type = string
    sensitive = true
}
variable "PM_PASSWORD" {
    type = string
    sensitive = true
}
variable "PLAYBOOK" {
    type = string
    default = "./files/playbook.yaml"
}

resource "proxmox_lxc" "grafana" {
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
        ip     = "10.10.0.10/24"
        gw = "10.10.0.1"
    }

    ssh_public_keys = "${var.ID_RSA_PUB}"

    tags = "Security Monitoring Grafana"
}

resource "ansible_host" "grafana" {
    name = trimsuffix(proxmox_lxc.grafana.network[0].ip, "/24")
    groups = [ "Security", "Grafana" ]
    
    depends_on = [ proxmox_lxc.grafana ]
}

resource "ansible_playbook" "grafana_playbook" {
    playbook   = "/home/h4ndl3/Projects/Terraform/modules/grafana/files/playbook.yaml"
    name = trimsuffix(proxmox_lxc.grafana.network[0].ip, "/24")
    replayable = true
    verbosity = 6

    

    connection {
        type        = "ssh"
        user        = "root"
        host        = trimsuffix(proxmox_lxc.grafana.network[0].ip, "/24")
    }
    
    depends_on = [ proxmox_lxc.grafana ]
}