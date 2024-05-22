variable "PM_API_URL" {
  description = "(Required) This is the target Proxmox API endpoint."
  type        = string
}

variable "PM_PROXY_SERVER" {
  description = "(Optional) Send provider api call to a proxy server for easy debugging."
  type        = string
  default     = null
}

# variable "PM_USER" {
#   description = "(Optional) The user, remember to include the authentication realm such as myuser@pam or myuser@pve."
#   type = string
# }

variable "PM_PASSWORD" {
  description = "(Optional) The password."
  type        = string
  sensitive   = true
}

# variable "PM_CPASS" {
#   description = "(Optional) The container password."
#   type = string
#   sensitive = true
# }

variable "PM_API_TOKEN_ID" {
  description = "(Optional) This is an API token you have previously created for a specific user."
  type        = string
  sensitive   = true
}

variable "PM_API_TOKEN_SECRET" {
  description = "(Optional) This uuid is only available when the token was initially created."
  type        = string
  sensitive   = true
}

variable "GRAFANA_USERNAME" {
  description = "Grafana application username."
  type        = string
}

variable "GRAFANA_PASSWORD" {
  description = "Grafana application pasword."
  type        = string
  sensitive   = true
}

# variable "GRAFANA_API_KEY" {
#   description = "Grafana API key."
#   type        = string
#   sensitive   = true
# }

variable "LOKI_WORKING_PATH" {
  description = "Working path for storage of chunck and rules for Loki."
  type        = string
}

variable "PROMETHEUS_WORKING_PATH" {
  description = "Working path for storage of chunck and rules for Prometheus."
  type        = string
}

# variable "PM_OTP" {
#   description = "(Optional) The 2FA OTP code."
#   type = string
#   sensitive = true
# }

# variable "PM_OTP_PROMPT" {
#   description = "(Optional) rompt for OTP 2FA code (if required)."
#   type = string
# }

variable "PM_TLS_INSECURE" {
  description = "(Optional) Disable TLS verification while connecting to the proxmox server."
  type        = bool
  default     = false
}

variable "PM_PARALLEL" {
  description = "(Optional) Allowed simultaneous Proxmox processes (e.g. creating resources)."
  type        = number
  default     = 4
}

variable "PM_LOG_ENABLE" {
  description = "(Optional) Enable debug logging, see the section below for logging details."
  type        = string
  default     = false
}

variable "PM_LOG_FILE" {
  description = "(Optional) If logging is enabled, the log file the provider will write logs to."
  type        = string
  default     = "terraform-plugin-proxmox.log"
}

variable "PM_LOG_LEVELS" {
  description = "(Optional) A map of log sources and levels."
  type        = map(string)
}

variable "PM_TIMEOUT" {
  description = "(Optional) Timeout value (seconds) for proxmox API calls."
  type        = number
  default     = 300
}

variable "PM_DEBUG" {
  description = "(Optional) Enable verbose output in proxmox-api-go"
  type        = bool
  default     = false
}

variable "ID_RSA_PUB" {
  description = "(Optional) SSH public key."
  type        = string
}

# variable "ANSIBLE_ROOT_PASS" {
#   type      = string
#   sensitive = true
# }

# variable "ANSIBLE_DB_PASS" {
#   type      = string
#   sensitive = true
# }

# variable "ANSIBLE_APP_PASS" {
#   type      = string
#   sensitive = true
# }