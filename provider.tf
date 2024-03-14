terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "proxmox" {
pm_api_url = var.PM_API_URL
# pm_proxy_server = 
pm_user = var.PM_USER
pm_password = var.PM_PASSWORD
# pm_api_token_id = var.PM_API_TOKEN_ID
# pm_api_token_secret = var.PM_API_TOKEN_SECRET
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