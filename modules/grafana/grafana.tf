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
}
variable "PM_CPASS" {
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
    password     = var.PM_CPASS
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


    network {
        name   = "eth0"
        bridge = "vmbr0"
        ip     = "dhcp"
    }

    tags = "Security Monitoring"

    provisioner "remote-exec" {
        # execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
        inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
        # inline_shebang  = "/bin/sh -x"
    }

}

resource "ansible_host" "grafana" {
    name = ansible_playbook.grafana_playbook.playbook
    groups = [ "Security", "Grafana" ]
    variables = {
        HOSTNAME = var.HOSTNAME
    }
}

resource "ansible_playbook" "grafana_playbook" {
    playbook   = "/home/h4ndl3/Projects/Terraform/modules/grafana/files/playbook.yaml"
    name       = var.HOSTNAME
    replayable = true
}