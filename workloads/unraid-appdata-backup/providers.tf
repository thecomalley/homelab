terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    healthchecksio = {
      source = "kristofferahl/healthchecksio"
    }
  }
}

provider "azurerm" {
  features {}
  # AZURERM_SUBSCRIPTION_ID 
}

provider "healthchecksio" {
  # HEALTHCHECKSIO_API_KEY
}
