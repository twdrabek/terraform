terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.2.0"
    }
    grafana = {
      source = "grafana/grafana"
      version = "3.7.0"
    }
  }
}

variable "HOSTNAME" {
  type    = string
  default = "grafana-stack"
}
variable "ID_RSA_PUB" {
  type      = string
  sensitive = true
}
variable "PM_PASSWORD" {
  type      = string
  sensitive = true
}
variable "GRAFANA_USERNAME" {
  type = string
}
variable "GRAFANA_PASSWORD" {
  type      = string
  sensitive = true
}
locals {
  grafana_ip = trimsuffix(proxmox_lxc.grafana-stack.network[0].ip, "/24")
}

resource "proxmox_lxc" "grafana-stack" {
  target_node  = "pve"
  hostname     = var.HOSTNAME
  ostemplate   = "Mass:vztmpl/ubuntu-23.10-standard_23.10-1_amd64.tar.zst"
  password     = var.PM_PASSWORD
  unprivileged = true
  onboot       = true
  start        = true

  rootfs {
    storage = "Mass"
    size    = "12G"
  }

  // Memory in MB
  memory = 16384

  nameserver = "10.10.0.5"

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.10.0.10/24"
    gw     = "10.10.0.1"
  }

  ssh_public_keys = var.ID_RSA_PUB

  tags = "Security Monitoring Grafana LGMT-Stack"
}

resource "ansible_host" "grafana-stack" {
  name   = local.grafana_ip
  groups = ["Security", "Grafana"]

  connection {
    type = "ssh"
    user = "root"
    host = this.name
  }

  depends_on = [
    proxmox_lxc.grafana-stack
  ]
}

resource "ansible_playbook" "grafana-stack_playbook" {
  playbook   = "/home/h4ndl3/Projects/Terraform/modules/grafana-stack/files/grafana.stack.playbook.yaml"    #grafana.config.playbook.yaml
  name       = ansible_host.grafana-stack.name
  replayable = true

  extra_vars = {
    GRAFANA_USERNAME = var.GRAFANA_USERNAME
    GRAFANA_PASSWORD = var.GRAFANA_PASSWORD
    GRAFANA_URL      = "http://${local.grafana_ip}:3000/"
  }

  depends_on = [
    ansible_host.grafana-stack
  ]
}

# resource "grafana_data_source" "loki" {
#   type = "loki"
#   name = "loki"
#   url  = "http://localhost:3100"

#   lifecycle {
#     ignore_changes = [json_data_encoded, http_headers]
#   }
# }

# resource "grafana_data_source" "tempo" {
#   type = "tempo"
#   name = "tempo"
#   url  = "http://localhost:3200"

#   lifecycle {
#     ignore_changes = [json_data_encoded, http_headers]
#   }
# }

# resource "grafana_data_source_config" "loki" {
#   uid = grafana_data_source.loki.uid

#   json_data_encoded = jsonencode({
#     derivedFields = [
#       {
#         datasourceUid = grafana_data_source.tempo.uid
#         matcherRegex  = "[tT]race_?[iI][dD]\"?[:=]\"?(\\w+)"
#         matcherType   = "regex"
#         name          = "traceID"
#         url           = "$${__value.raw}"
#       }
#     ]
#   })
# }

# resource "grafana_data_source_config" "tempo" {
#   uid = grafana_data_source.tempo.uid

#   json_data_encoded = jsonencode({
#     tracesToLogsV2 = {
#       customQuery     = true
#       datasourceUid   = grafana_data_source.loki.uid
#       filterBySpanID  = false
#       filterByTraceID = false
#       query           = "|=\"$${__trace.traceId}\" | json"
#     }
#   })
# }