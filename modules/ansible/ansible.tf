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

variable "PM_CPASS" {
    type = string
    sensitive = true
    description = "Container password"
}
variable "TF_VAR_ID_RSA_PUB" {
    type = string
}

resource "proxmox_lxc" "ansible" {
    target_node  = "pve"
    hostname     = "Ansible"
    ostemplate   = "Mass:vztmpl/ubuntu-23.10-standard_23.10-1_amd64.tar.zst"
    password     = var.PM_CPASS
    unprivileged = true
    start = true
    onboot = true

    ssh_public_keys = <<-EOT
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6oiNDN1Hca018vNYdCn90MnEjNSDpSpNApk4nwwkfs377pRkAwvin7vB0rQCMItp35bCaeyfR/K72aD4eWWxibUh+hymlAMlYALUd8w5RPk8L5Lg05yW45rjd73BH3dCwFAPdCXDLnSzdzJH1P3OdsnJgR3PfWKxkXuPDaB/I0QBnuSYalQdWKpPrR/wyejRHfL8rP4m7CSf2UflF2cn3C8rQkZL7imuMMJaKN4e1QVr29s7rK5axNaix3A+uu9w76R+3spbclZjmbhjvM7bu9Hz9LFu2MiHe5ghIe02cHUsQiqS05aBqUhhhwjI/MycmCxdI2HsNVEUzHp3ZlhAMGtRAfcBgVGYWhP5/CyZbMybAqxb0C1jV2+VeBOyjL8A+DkEJC9ki+XlHppoMgkkvBjcs+c2EOHcAY3q4U5zc1Xr95HFptKKnGN/FPLT1SVR9QIpLljNOXk9V1xnf9loxuw90/H1LE4V0LuzMuKr7+CinkWaeOuVeQSD/1EABKzU= h4ndl3@ubuntu
    EOT

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