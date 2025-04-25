terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.27.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "e903e03e-c3ba-49ed-8771-53e75dab7364"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-jenkins-terraform"
  location = "Southeast Asia"
}

resource "azurerm_app_service_plan" "asp" {
  name                = "app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "app" {
  name                = "webapiterraform122002"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
    linux_fx_version = "DOTNETCORE|8.0"

    # Enable SCM Basic Auth publishing credentials
    scm_use_main_ip_restriction = false

    # Enable FTP Basic Auth publishing credentials
    ftps_state = "AllAllowed"
  }
  
  app_settings = {
    "WEBSITE_DISABLE_SCM_SEPARATION"         = "false"
    "SCM_BASIC_AUTH_ENABLED"                 = "true"
    "FTP_BASIC_AUTH_ENABLED"                 = "true"
  }
}
