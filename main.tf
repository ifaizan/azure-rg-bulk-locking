terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.87.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Running bash script and using it as a datasource
data "external" "rg" {
  program = ["bash", "${path.module}/script.sh"]

  query = {
    subscription = var.subscription_id,
  }
}

# Running a loop to lock all resource groups in a particular subscription
resource "azurerm_management_lock" "rg_lock" {
  count      = length(jsondecode(data.external.rg.result.id))
  name       = "Resource-Group-Lock"
  scope      = jsondecode(data.external.rg.result.id)[count.index]
  lock_level = "ReadOnly"
  notes      = "This Resource Group is Read-Only"
}

output "result" {
  value = jsondecode(data.external.rg.result.id)
}
