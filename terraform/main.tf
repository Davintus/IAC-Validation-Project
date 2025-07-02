terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "python-app-rg"
  location = "westeurope"
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "python-app-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Create a disk encryption set (required for CKV_AZURE_117)
resource "azurerm_disk_encryption_set" "example" {
  name                = "python-app-des"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  key_vault_key_id    = azurerm_key_vault_key.example.id # Replace with your Key Vault Key ID
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "python-app-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "pythonapp"
  sku_tier            = "Paid"
  local_account_disabled = true # Fixes CKV_AZURE_141
  private_cluster_enabled = true # Fixes CKV_AZURE_115
  automatic_channel_upgrade = "patch" # Fixes CKV_AZURE_171

  default_node_pool {
    name                = "default"
    vm_size             = "Standard_D2_v2"
    os_disk_type        = "Ephemeral"
    max_pods            = 50
    min_count           = 1
    max_count           = 3
    node_count          = 2
    enable_host_encryption = true # Fixes CKV_AZURE_227
    disk_encryption_set_id = azurerm_disk_encryption_set.example.id # Fixes CKV_AZURE_117
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  api_server_access_profile {
    authorized_ip_ranges = ["10.3.0.0/16"]
  }

  azure_policy_enabled = true

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true # Fixes CKV_AZURE_172
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
