terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.17.0"
    }

  }
}

provider "azurerm" {
  features {}

}

resource "azurerm_resource_group" "terrform_practices" {
  name     = "terrform_practices"
  location = "North Europe"
}

resource "azurerm_app_service_plan" "plandemo8" {
  name                = "plandemo8"
  location            = "West Europe"
  resource_group_name = "terrform_practices"

  sku {
    tier = "Free"
    size = "F1"
  }

  depends_on = [azurerm_resource_group.terrform_practices]
}

resource "azurerm_app_service" "firedemo45" {
  name                = "firedemo45"
  location            = "West Europe"
  resource_group_name = "terrform_practices"
  app_service_plan_id = azurerm_app_service_plan.plandemo8.id

  site_config {
    always_on                = false
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  depends_on = [
    azurerm_app_service_plan.plandemo8

  ]

}

resource "azurerm_mssql_server" "sqlserver000000001234" {
  name                         = "sqlserver000000001234"
  resource_group_name          = "terrform_practices"
  location                     = "West Europe"
  version                      = "12.0"
  administrator_login          = "sqlusr"
  administrator_login_password = var.sql_password
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_database" "app-db" {
  name         = "app-db"
  server_id    = azurerm_mssql_server.sqlserver000000001234.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "basic"
  depends_on = [
    azurerm_mssql_server.sqlserver000000001234
  ]
}
