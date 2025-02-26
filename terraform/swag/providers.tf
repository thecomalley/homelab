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
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "uptimerobot" {
  api_key = var.uptimerobot_api_key
}
