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

provider "proxmox" {
pm_api_url = var.PM_API_URL
# pm_proxy_server = 
# pm_user = var.PM_USER
# pm_password = var.PM_PASSWORD
pm_api_token_id = var.PM_API_TOKEN_ID
pm_api_token_secret = var.PM_API_TOKEN_SECRET
# pm_otp = 
# pm_otp_prompt = 
pm_tls_insecure = true
# pm_parallel = 
pm_log_enable = true 
pm_log_file = var.PM_LOG_FILE
pm_log_levels = var.PM_LOG_LEVELS
# pm_timeout = 
pm_debug = true
}

module "ansible" {
    source = "./modules/ansible"

    PM_PASSWORD = var.PM_PASSWORD
    ID_RSA_PUB = "${var.ID_RSA_PUB}"
}

#connecting to the Ansible control node using SSH connection
resource "null_resource" "nullremote1" {
    depends_on = [module.ansible]
    connection {
    type     = "ssh"
    user     = "root"
    # password = "${var.PM_PASSWORD}"
    host= proxmox.ansible.ip
    }
}

module "gitlab" {
    source = "./modules/gitlab"

    PM_PASSWORD = var.PM_PASSWORD
    ID_RSA_PUB = "${var.ID_RSA_PUB}"
}

module "nginx" {
    source = "./modules/nginx"

    PM_PASSWORD = var.PM_PASSWORD
    ID_RSA_PUB = "${var.ID_RSA_PUB}"
}

module "grafana" {
    source = "./modules/grafana"

    PM_PASSWORD = var.PM_PASSWORD
    ID_RSA_PUB = "${var.ID_RSA_PUB}"
}

module "loki" {
    source = "./modules/loki"

    PM_PASSWORD = var.PM_PASSWORD
    ID_RSA_PUB = "${var.ID_RSA_PUB}"
}


# module "pihole" {
#   source = "./modules/pihole"

#   PM_PASSWORD = var.PM_PASSWORD
# }

#   Loki -> Logging https://grafana.com/docs/loki/latest/
#   Prometheus -> Metrics https://grafana.com/docs/grafana/latest/datasources/prometheus/
#   Mimir -> https://grafana.com/docs/mimir/latest/
#   SNORT -> NIDPS  https://www.snort.org/
#   Tempo -> Tracing https://grafana.com/docs/tempo/latest/
# Guacamole -> Web RAT
# Finalize student image and incorporate.
# Add targets

