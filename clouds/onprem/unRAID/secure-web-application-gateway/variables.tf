variable "apps" {
  description = "A list of applications to reverse proxy"
  type        = list(string)
}

variable "domain_name" {
  description = "The domain name"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare zone ID"
  type        = string
}

variable "unraid_hostname" {
  description = "The hostname of the Unraid server"
  type        = string
}
