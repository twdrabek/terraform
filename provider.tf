terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

# variable "PM_API_URL" {
#   description = "(Required) This is the target Proxmox API endpoint."
#   type = string  
# }

# variable "PM_PROXY_SERVER" {
#   description = "(Optional) Send provider api call to a proxy server for easy debugging."
#   type = string
#   default = null
# }

# variable "PM_USER" {
#   description = "(Optional) The user, remember to include the authentication realm such as myuser@pam or myuser@pve."
#   type = string
# }

# variable "PM_PASSWORD" {
#   description = "(Optional) The password."
#   type = string
#   sensitive = true
# }

# variable "PM_API_TOKEN_ID" {
#   description = "(Optional) This is an API token you have previously created for a specific user."
#   type = string
#   sensitive = true
#   # default = "env(var.PKR_VAR_pm_api_token_id)"
# }

# variable "PM_API_TOKEN_SECRET" {
#   description = "(Optional) This uuid is only available when the token was initially created."
#   type = string
#   sensitive = true
#   # default = "env(var.PKR_VAR_pm_api_token_secret)"
# }

# variable "PM_OTP" {
#   description = "(Optional) The 2FA OTP code."
#   type = string
#   sensitive = true
# }

# variable "PM_OTP_PROMPT" {
#   description = "(Optional) rompt for OTP 2FA code (if required)."
#   type = string
# }

# variable "PM_TLS_INSECURE" {
#   description = "(Optional) Disable TLS verification while connecting to the proxmox server."
#   type = bool
#   default = false
# }

# variable "PM_PARALLEL" {
#   description = "(Optional) Allowed simultaneous Proxmox processes (e.g. creating resources)."
#   type = number
#   default = 4
# }

# variable "PM_LOG_ENABLE" {
#   description = "(Optional) Enable debug logging, see the section below for logging details."
#   type = string
#   default = false
# }

# variable "PM_LOG_FILE" {
#   description = "(Optional) If logging is enabled, the log file the provider will write logs to."
#   type = string
#   default = "terraform-plugin-proxmox.log"
# }

# variable  "PM_LOG_LEVELS" {
#   description = "(Optional) A map of log sources and levels."
#   type = map(string)
# }

# variable "PM_TIMEOUT" {
#   description = "(Optional) Timeout value (seconds) for proxmox API calls."
#   type = number
#   default = 300
# }

# variable "PM_DEBUG" {
#   description = "(Optional) Enable verbose output in proxmox-api-go"
#   type = bool
#   default = false
# }

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