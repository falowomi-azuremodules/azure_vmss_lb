resource "azurerm_resource_group" "rg" {
  name                                                                                  = var.req_rg_name
  location                                                                              = var.req_rg_location
}

resource "azurerm_virtual_network" "vnet" {
  name                                                                                  = var.req_vnet_info.vnet_name
  address_space                                                                         = var.req_vnet_info.vnet_address_space
  location                                                                              = azurerm_resource_group.rg.location
  resource_group_name                                                                   = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "vnet_subnet" {
  name                                                                                  = var.req_subnet_info.subnet_name
  resource_group_name                                                                   = azurerm_resource_group.rg.name
  virtual_network_name                                                                  = azurerm_virtual_network.vnet.name
  address_prefixes                                                                      = var.req_subnet_info.subnet_address_prefixes
}

resource "azurerm_subnet_network_security_group_association" "vnet_subnet_association" {
  subnet_id                                                                             = azurerm_subnet.vnet_subnet.id
  network_security_group_id                                                             = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_group" "nsg" {
  name                                                                                  = var.req_nsg_name
  location                                                                              = azurerm_resource_group.rg.location
  resource_group_name                                                                   = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = var.req_nsg_rules_info

    content {
      name                                                                              = security_rule.value.nsg_rule_name
      priority                                                                          = security_rule.value.nsg_rule_priority
      direction                                                                         = security_rule.value.nsg_rule_direction
      access                                                                            = security_rule.value.nsg_rule_access
      protocol                                                                          = security_rule.value.nsg_rule_protocol
      source_port_range                                                                 = security_rule.value.nsg_rule_source_port_range
      destination_port_range                                                            = security_rule.value.nsg_rule_destination_port_range
      source_address_prefix                                                             = security_rule.value.nsg_rule_source_address_prefix
      destination_address_prefix                                                        = security_rule.value.nsg_rule_destination_address_prefix
    }
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                                                                                  = var.req_pip_info.pip_name
  location                                                                              = azurerm_resource_group.rg.location
  resource_group_name                                                                   = azurerm_resource_group.rg.name
  allocation_method                                                                     = var.req_pip_info.pip_allocation_method
  domain_name_label                                                                     = var.req_pip_info.pip_domain_name_label
}

resource "azurerm_lb" "lb" {
  name                                                                                  = var.req_load_balancer_info.lb_name
  location                                                                              = azurerm_resource_group.rg.location
  resource_group_name                                                                   = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                                                                                = var.req_load_balancer_info.lb_frontend_ip_config_name
    public_ip_address_id                                                                = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name                                                                   = azurerm_resource_group.rg.name
  loadbalancer_id                                                                       = azurerm_lb.lb.id
  name                                                                                  = var.req_load_balancer_info.lb_bepool_name
}


resource "azurerm_lb_probe" "health_probe" {
  resource_group_name                                                                   = azurerm_resource_group.rg.name
  loadbalancer_id                                                                       = azurerm_lb.lb.id
  name                                                                                  = var.req_load_balancer_info.lb_hp_name
  protocol                                                                              = var.req_load_balancer_info.lb_hp_protocol
  request_path                                                                          = var.req_load_balancer_info.lb_hp_request_path
  port                                                                                  = var.req_load_balancer_info.lb_hp_port
}

resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name                                                                   = azurerm_resource_group.rg.name
  loadbalancer_id                                                                       = azurerm_lb.lb.id
  name                                                                                  = var.req_load_balancer_info.lb_rule_name
  protocol                                                                              = var.req_load_balancer_info.lb_rule_protocol
  frontend_port                                                                         = var.req_load_balancer_info.lb_rule_frontend_port
  backend_port                                                                          = var.req_load_balancer_info.lb_rule_backend_port
  frontend_ip_configuration_name                                                        = var.req_load_balancer_info.lb_frontend_ip_config_name
  probe_id                                                                              = azurerm_lb_probe.health_probe.id
  backend_address_pool_id                                                               = azurerm_lb_backend_address_pool.bpepool.id
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                                                                                  = var.req_vmss_info.vmss_name
  resource_group_name                                                                   = azurerm_resource_group.rg.name
  location                                                                              = azurerm_resource_group.rg.location
  sku                                                                                   = var.req_vmss_info.vmss_sku
  instances                                                                             = var.req_vmss_info.vmss_instances
  admin_username                                                                        = var.req_vmss_info.vmss_admin_username
  admin_password                                                                        = var.req_vmss_info.vmss_admin_password
  disable_password_authentication                                                       = var.req_vmss_info.vmss_disable_password_authentication

  automatic_os_upgrade_policy {
    enable_automatic_os_upgrade                                                         = var.req_vmss_info.vmss_enable_automatic_os_upgrade
    disable_automatic_rollback                                                          = var.req_vmss_info.vmss_disable_automatic_rollback
  }

  upgrade_mode                                                                          = var.req_vmss_info.vmss_upgrade_mode

  automatic_instance_repair {
    enabled                                                                             = var.req_vmss_info.vmss_enabled
  }

  rolling_upgrade_policy {
    max_batch_instance_percent                                                          = var.req_vmss_info.vmss_max_batch_instance_percent
    max_unhealthy_instance_percent                                                      = var.req_vmss_info.vmss_max_unhealthy_instance_percent
    max_unhealthy_upgraded_instance_percent                                             = var.req_vmss_info.vmss_max_unhealthy_upgraded_instance_percent
    pause_time_between_batches                                                          = var.req_vmss_info.vmss_pause_time_between_batches
  }

  source_image_reference {
    publisher                                                                           = var.req_vmss_info.vmss_instance_publisher
    offer                                                                               = var.req_vmss_info.vmss_instance_offer
    sku                                                                                 = var.req_vmss_info.vmss_instance_sku
    version                                                                             = var.req_vmss_info.vmss_instance_version
  }

  os_disk {
    storage_account_type                                                                = var.req_vmss_info.vmss_storage_account_type
    caching                                                                             = var.req_vmss_info.vmss_caching
  }

  network_interface {
    name    = var.req_vmss_info.vmss_nic_name
    primary = var.req_vmss_info.vmss_nic_primary

    ip_configuration {
      name                                                                              = var.req_vmss_info.vmss_nic_ipconfig_name
      primary                                                                           = var.req_vmss_info.vmss_nic_ipconfig_primary
      subnet_id                                                                         = azurerm_subnet.vnet_subnet.id
      load_balancer_backend_address_pool_ids                                            = [azurerm_lb_backend_address_pool.bpepool.id]
      public_ip_address {
        name                                                                            = var.req_vmss_info.vmss_nic_pip_name
        idle_timeout_in_minutes                                                         = var.req_vmss_info.vmss_nic_pip_idle_timeout_in_minutes
        domain_name_label                                                               = var.req_vmss_info.vmss_nic_pip_domain_name_label
      }
    }
  }

  health_probe_id                                                                       = azurerm_lb_probe.health_probe.id

  depends_on = [
    azurerm_lb_rule.lb_rule,
  ]
}

resource "azurerm_template_deployment" "vmss-extension" {
  name                                                                                  = "${azurerm_linux_virtual_machine_scale_set.vmss.name}-extension"
  resource_group_name                                                                   = azurerm_resource_group.rg.name

  template_body                                                                         = file("custom_extension.json")

  parameters = {
    "vmName" = azurerm_linux_virtual_machine_scale_set.vmss.name
  }

  deployment_mode                                                                       = "Incremental"
}

resource "azurerm_monitor_autoscale_setting" "autoscaling" {
  name                                                                                  = var.req_autoscale_info.autoscale_name
  resource_group_name                                                                   = azurerm_resource_group.rg.name
  location                                                                              = azurerm_resource_group.rg.location
  target_resource_id                                                                    = azurerm_linux_virtual_machine_scale_set.vmss.id

  profile {
    name                                                                                = var.req_autoscale_info.autoscale_profile_name

    capacity {
      default                                                                           = var.req_autoscale_info.autoscale_profile_capacity_default
      minimum                                                                           = var.req_autoscale_info.autoscale_profile_capacity_minimum
      maximum                                                                           = var.req_autoscale_info.autoscale_profile_capacity_maximum
    }

    dynamic "rules" {
      for_each                                                                          = var.req_autoscale_profile_info

      content {
        metric_trigger {
          metric_name                                                                   = rules.value.profile_rules_metric_name
          metric_resource_id                                                            = azurerm_linux_virtual_machine_scale_set.vmss.id
          time_grain                                                                    = rules.value.profile_rules_time_grain
          statistic                                                                     = rules.value.profile_rules_statistic
          time_window                                                                   = rules.value.profile_rules_time_window
          time_aggregation                                                              = rules.value.profile_rules_time_aggregation
          operator                                                                      = rules.value.profile_rules_operator
          threshold                                                                     = rules.value.profile_rules_threshold
        }

        scale_action {
          direction                                                                     = rules.value.profile_rules_direction
          type                                                                          = rules.value.profile_rules_type
          value                                                                         = rules.value.profile_rules_value
          cooldown                                                                      = rules.value.profile_rules_cooldown
        }
      }
    }
  }
}