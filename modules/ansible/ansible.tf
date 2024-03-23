terraform {
    required_providers {
        proxmox = {
        source = "Telmate/proxmox"
        version = "3.0.1-rc1"
        }
        # ansible = {
        # source = "ansible/ansible"
        # version = "1.2.0"
        # }
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

resource "proxmox_lxc" "ansible" {
    target_node  = "pve"
    hostname     = "ansible"
    ostemplate   = "Mass:vztmpl/ubuntu-23.10-standard_23.10-1_amd64.tar.zst"
    password     = var.PM_PASSWORD
    unprivileged = true
    start = true
    onboot = true

    ssh_public_keys = "${var.ID_RSA_PUB}"

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

    tags = "Service Administration Automation"

}

# resource "ansible_playbook" "playbook" {
#     depends_on = [ proxmox_lxc.ansible ]
#     playbook   = "./files/"
#     name       = proxmox_lxc.ansible.hostname
#     replayable = true

#     extra_vars = {
#         var_a = "Some variable"
#         var_b = "Another variable"
#     }
# }