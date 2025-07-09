variable "apps" {
  description = "A map of applications to be configured with SWAG, each with external and internal access settings"
  type = map(object({
    external = optional(bool, true) # Default to true for external access
    internal = optional(bool, true) # Default to true for internal access
  }))
}

variable "domain_name" {
  description = "The domain name"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare zone ID"
  type        = string
}

variable "unraid_username" {
  description = "The username for the Unraid server (Used by Ansible)"
  type        = string
}

variable "unraid_hostname" {
  description = "The hostname of the Unraid server (Used by Ansible)"
  type        = string
}

variable "adguard_host" {
  description = "The host of the AdGuard server"
  type        = string
}

variable "adguard_username" {
  description = "The username for AdGuard"
  type        = string
}

variable "adguard_password" {
  description = "The password for AdGuard"
  type        = string
}

variable "swag_external_cname" {
  description = "The CNAME for the SWAG server to be used in external DNS records, (CNAME is used to support Dynamic DNS)"
  type        = string
}

variable "swag_internal_ip" {
  description = "The internal IP address of the SWAG server"
  type        = string
}
