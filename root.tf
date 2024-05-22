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
  }
}

# locals {
#   decoded_vault_yaml = yamldecode(ansible_vault.secrets.yaml)
# }

# resource "ansible_vault" "secrets" {
#   vault_file          = "vault.yml"
#   vault_password_file = "/path/to/file"
# }

provider "proxmox" {
  pm_api_url = var.PM_API_URL
  # pm_proxy_server = 
  # pm_user = var.PM_USER
  # pm_password = var.PM_PASSWORD
  pm_api_token_id     = var.PM_API_TOKEN_ID
  pm_api_token_secret = var.PM_API_TOKEN_SECRET
  # pm_otp = 
  # pm_otp_prompt = 
  pm_tls_insecure = true
  # pm_parallel = 
  pm_log_enable = true
  pm_log_file   = var.PM_LOG_FILE
  pm_log_levels = var.PM_LOG_LEVELS
  # pm_timeout = 
  pm_debug = true
}

provider "ansible" {}

# module "gitlab" {
#     source = "./modules/gitlab"

#     PM_PASSWORD = var.PM_PASSWORD
#     ID_RSA_PUB = "${var.ID_RSA_PUB}"
# }

module "nginx" {
    source = "./modules/nginx"

    PM_PASSWORD = var.PM_PASSWORD
    ID_RSA_PUB = "${var.ID_RSA_PUB}"
}

module "grafana" {
  source = "./modules/grafana"

  PM_PASSWORD      = var.PM_PASSWORD
  ID_RSA_PUB       = var.ID_RSA_PUB
  GRAFANA_USERNAME = var.GRAFANA_USERNAME
  GRAFANA_PASSWORD = var.GRAFANA_PASSWORD
}

module "loki" {
  #   Loki -> Logging https://grafana.com/docs/loki/latest/
  source = "./modules/loki"

  PM_PASSWORD       = var.PM_PASSWORD
  ID_RSA_PUB        = var.ID_RSA_PUB
}

module "prometheus" {
  #   Prometheus -> Metrics https://grafana.com/docs/grafana/latest/datasources/prometheus/
  source = "./modules/prometheus"

  PM_PASSWORD             = var.PM_PASSWORD
  ID_RSA_PUB              = var.ID_RSA_PUB
}

#################################################################################################
# Add data source for "prometheus_targets", Ansible host file might be useful or the statefile. #
#################################################################################################


module "mimir" {
#   Mimir -> https://grafana.com/docs/mimir/latest/
    source = "./modules/mimir"

    PM_PASSWORD = var.PM_PASSWORD
    ID_RSA_PUB = "${var.ID_RSA_PUB}"
}

module "tempo" {
#   Tempo -> Tracing https://grafana.com/docs/tempo/latest/
    source = "./modules/tempo"

    PM_PASSWORD = var.PM_PASSWORD
    ID_RSA_PUB = "${var.ID_RSA_PUB}"
}

# module "pihole" {
#     source = "./modules/pihole"

#     PM_PASSWORD = var.PM_PASSWORD
# }

#   SNORT -> NIDPS  https://www.snort.org/

# Guacamole -> Web RAT
# Finalize student image and incorporate.
# Add targets
