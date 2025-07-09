terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.0.0-rc1"
    }
    uptimerobot = {
      source  = "cogna-public/uptimerobot"
      version = "0.8.4"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
    adguard = {
      source  = "gmichels/adguard"
      version = "1.6.2"
    }
  }
}

provider "cloudflare" {
  # CLOUDFLARE_API_TOKEN
}

provider "uptimerobot" {
  # UPTIMEROBOT_API_KEY
}

# configuration for the provider
provider "adguard" {
  host     = var.adguard_host
  username = var.adguard_username
  password = var.adguard_password
  scheme   = "http" # defaults to https
  timeout  = 5      # in seconds, defaults to 10
  insecure = true   # when `true` will skip TLS validation
}
