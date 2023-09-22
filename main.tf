terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "adi-rg" {
  name     = "adi-resources"
  location = "East Us"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "adi-vn" {
  name                = "adi-network"
  resource_group_name = azurerm_resource_group.adi-rg.name
  location            = azurerm_resource_group.adi-rg.location
  address_space       = ["10.123.0.0/16"]
  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "adi-subnet" {
  name                 = "adi-subnet"
  resource_group_name  = azurerm_resource_group.adi-rg.name
  virtual_network_name = azurerm_virtual_network.adi-vn.name
  address_prefixes     = ["10.123.1.0/24"]
}


resource "azurerm_network_security_group" "adi-sg" {
  name                = "adi-sg"
  location            = azurerm_resource_group.adi-rg.location
  resource_group_name = azurerm_resource_group.adi-rg.name

  security_rule {
    name                       = "adi-sg1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
  }
}