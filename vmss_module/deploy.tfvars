res_rg_name                                                             = "test_rg"
res_rg_location                                                         = "northcentralus"
res_vnet_info = {
  vnet_name                                                             = "test_vnet"
  vnet_address_space                                                    = ["10.0.0.0/16"]
}

res_subnet_info = {
  subnet_name                                                           = "compute_subnet"
  subnet_address_prefixes                                               = ["10.0.1.0/24"]
}

res_nsg_name                                                            = "test_nsg"

res_nsg_rules_info = [
  {
    nsg_rule_name                                                       = "remote_management_ports"
    nsg_rule_priority                                                   = 100
    nsg_rule_direction                                                  = "Inbound"
    nsg_rule_access                                                     = "Deny"
    nsg_rule_protocol                                                   = "Tcp"
    nsg_rule_source_port_range                                          = "*"
    nsg_rule_destination_port_range                                     = "22"
    nsg_rule_source_address_prefix                                      = "*"
    nsg_rule_destination_address_prefix                                 = "*"
  },
  {
    nsg_rule_name                                                       = "Allow_Http_Traffic"
    nsg_rule_priority                                                   = 101
    nsg_rule_direction                                                  = "Inbound"
    nsg_rule_access                                                     = "Allow"
    nsg_rule_protocol                                                   = "Tcp"
    nsg_rule_source_port_range                                          = "*"
    nsg_rule_destination_port_range                                     = "80"
    nsg_rule_source_address_prefix                                      = "*"
    nsg_rule_destination_address_prefix                                 = "*"
  }
]
res_pip_info = {
  pip_name                                                              = "loadbalancer_pip"
  pip_allocation_method                                                 = "Static"
  pip_domain_name_label                                                 = "test-domain-name"
}

res_load_balancer_info = {
  lb_name                                                               = "test_lb"
  lb_frontend_ip_config_name                                            = "lb_frontend_ip_config"
  lb_bepool_name                                                        = "lb_backend_pool"
  lb_hp_name                                                            = "http-probe"
  lb_hp_protocol                                                        = "Http"
  lb_hp_request_path                                                    = "/"
  lb_hp_port                                                            = 80
  lb_rule_name                                                          = "lb_http_rule"
  lb_rule_protocol                                                      = "Tcp"
  lb_rule_frontend_port                                                 = 80
  lb_rule_backend_port                                                  = 80
}

res_vmss_info = {
  vmss_name                                                             = "testvmss"
  vmss_sku                                                              = "Standard_DS12_v2"
  vmss_instances                                                        = 1
  vmss_admin_username                                                   = "adminuser"
  vmss_admin_password                                                   = "AzurePassword123!"
  vmss_disable_password_authentication                                  = false
  vmss_enable_automatic_os_upgrade                                      = true
  vmss_disable_automatic_rollback                                       = false
  vmss_upgrade_mode                                                     = "Automatic"
  vmss_enabled                                                          = true
  vmss_max_batch_instance_percent                                       = 20
  vmss_max_unhealthy_instance_percent                                   = 20
  vmss_max_unhealthy_upgraded_instance_percent                          = 5
  vmss_pause_time_between_batches                                       = "PT0S"
  vmss_instance_publisher                                               = "Canonical"
  vmss_instance_offer                                                   = "UbuntuServer"
  vmss_instance_sku                                                     = "16.04-LTS"
  vmss_instance_version                                                 = "latest"
  vmss_storage_account_type                                             = "Premium_LRS"
  vmss_caching                                                          = "ReadWrite"
  vmss_nic_name                                                         = "vmss_network_profile"
  vmss_nic_primary                                                      = true
  vmss_nic_ipconfig_name                                                = "IPConfig"
  vmss_nic_ipconfig_primary                                             = true
  vmss_nic_pip_name                                                     = "test_vmss_pip"
  vmss_nic_pip_idle_timeout_in_minutes                                  = 10
  vmss_nic_pip_domain_name_label                                        = "testazurepiptest"
}

res_autoscale_info_autoscale_name                                       = "test_autoscaling"
res_autoscale_info_autoscale_profile_name                               = "defaultProfile"
res_autoscale_info_autoscale_profile_capacity_default                   = 1
res_autoscale_info_autoscale_profile_capacity_minimum                   = 1
res_autoscale_info_autoscale_profile_capacity_maximum                   = 4

res_autoscale_profile_info = [
  {
    profile_rules_metric_name                                           = "Percentage CPU"
    profile_rules_time_grain                                            = "PT1M"
    profile_rules_statistic                                             = "Average"
    profile_rules_time_window                                           = "PT5M"
    profile_rules_time_aggregation                                      = "Average"
    profile_rules_operator                                              = "GreaterThan"
    profile_rules_threshold                                             = 75
    profile_rules_direction                                             = "Increase"
    profile_rules_type                                                  = "ChangeCount"
    profile_rules_value                                                 = "1"
    profile_rules_cooldown                                              = "PT1M"
  },
  {
    profile_rules_metric_name                                           = "Percentage CPU"
    profile_rules_time_grain                                            = "PT1M"
    profile_rules_statistic                                             = "Average"
    profile_rules_time_window                                           = "PT5M"
    profile_rules_time_aggregation                                      = "Average"
    profile_rules_operator                                              = "LessThan"
    profile_rules_threshold                                             = 25
    profile_rules_direction                                             = "Decrease"
    profile_rules_type                                                  = "ChangeCount"
    profile_rules_value                                                 = "1"
    profile_rules_cooldown                                              = "PT1M"
  }
]