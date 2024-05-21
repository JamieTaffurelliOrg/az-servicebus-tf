terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [azurerm.logs, azurerm.dns]
      source                = "hashicorp/azurerm"
      version               = "~> 3.104"
    }
  }
  required_version = "~> 1.6.0"
}
