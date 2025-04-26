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
  # CLOUDFLARE_API_TOKEN
}

provider "uptimerobot" {
  # UPTIMEROBOT_API_KEY
}
