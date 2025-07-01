resource "azurerm_kubernetes_cluster" "aks" {
  name                = "python-app-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "pythonapp"
  private_cluster_enabled = true
  sku_tier            = "Paid" # Fixes CKV_AZURE_170

  default_node_pool {
    name                = "default"
    node_count          = 2
    vm_size             = "Standard_D2_v2"
    enable_auto_scaling = true
    max_pods            = 50    # Fixes CKV_AZURE_168
    os_disk_type        = "Ephemeral" # Fixes CKV_AZURE_226
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure" # Fixes CKV2_AZURE_29
    network_policy = "azure" # Fixes CKV_AZURE_7
  }

  api_server_access_profile {
    authorized_ip_ranges = ["<YOUR_IP>/32"] # Fixes CKV_AZURE_6
  }

  azure_policy_enabled = true # Fixes CKV_AZURE_116

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id # Fixes CKV_AZURE_4
  }

  # Add other required attributes...
}
