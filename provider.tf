# Provider Block
provider "azurerm" {
 features {}          
}

# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  backend "azurerm" {
    
  } 
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }   
  }
}

