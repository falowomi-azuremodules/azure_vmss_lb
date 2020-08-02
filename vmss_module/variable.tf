variable "res_rg_name" {
  type        = string
  description = "Resource Group Name"
}

variable "res_rg_location" {
  type        = string
  description = "Resource Group Location"
}

variable "res_vnet_info" {
  type = object({
    vnet_name          = string
    vnet_address_space = list(string)
  })
  description = "Virtual Network Info"

}

variable "res_subnet_info" {
  type = object({
    subnet_name             = string
    subnet_address_prefixes = list(string)
  })
  description = "Vnet Subnet Info"
}

variable "res_nsg_name" {
  type        = string
  description = "Network Security Group Name"
}

variable "res_nsg_rules_info" {
  type = list(object({
    nsg_rule_name                       = string
    nsg_rule_priority                   = number
    nsg_rule_direction                  = string
    nsg_rule_access                     = string
    nsg_rule_protocol                   = string
    nsg_rule_source_port_range          = string
    nsg_rule_destination_port_range     = string
    nsg_rule_source_address_prefix      = string
    nsg_rule_destination_address_prefix = string
  }))
  description = "Network Security Group Info"
}

variable "res_pip_info" {
  type = object({
    pip_name              = string
    pip_allocation_method = string
    pip_domain_name_label = string
  })
  description = "Public IP Info"
}

variable "res_load_balancer_info" {
  type = object({
    lb_name                    = string
    lb_frontend_ip_config_name = string
    lb_bepool_name             = string
    lb_hp_name                 = string
    lb_hp_protocol             = string
    lb_hp_request_path         = string
    lb_hp_port                 = number
    lb_rule_name               = string
    lb_rule_protocol           = string
    lb_rule_frontend_port      = number
    lb_rule_backend_port       = number
  })
  description = "Load Balancer Info"
}

variable "res_vmss_info" {
  type = object({
    vmss_name                                    = string
    vmss_sku                                     = string
    vmss_instances                               = number
    vmss_admin_username                          = string
    vmss_admin_password                          = string
    vmss_disable_password_authentication         = bool
    vmss_enable_automatic_os_upgrade             = bool
    vmss_disable_automatic_rollback              = bool
    vmss_upgrade_mode                            = string
    vmss_enabled                                 = bool
    vmss_max_batch_instance_percent              = number
    vmss_max_unhealthy_instance_percent          = number
    vmss_max_unhealthy_upgraded_instance_percent = number
    vmss_pause_time_between_batches              = string
    vmss_instance_publisher                      = string
    vmss_instance_offer                          = string
    vmss_instance_sku                            = string
    vmss_instance_version                        = string
    vmss_storage_account_type                    = string
    vmss_caching                                 = string
    vmss_nic_name                                = string
    vmss_nic_primary                             = bool
    vmss_nic_ipconfig_name                       = string
    vmss_nic_ipconfig_primary                    = bool
    vmss_nic_pip_name                            = string
    vmss_nic_pip_idle_timeout_in_minutes         = number
    vmss_nic_pip_domain_name_label               = string
  })
  description = "Virtual Machine Scale Set Info"
}

variable "res_autoscale_info_autoscale_name" {
  type = string
  description = "VMSS Autoscaling Name"
}

variable "res_autoscale_info_autoscale_profile_name" {
  type = string
  description = "VMSS Autoscaling Profile Name"
}

variable "res_autoscale_info_autoscale_profile_capacity_default" {
  type = string
  description = "VMSS Autoscaling Profile Capacity Default"
}

variable "res_autoscale_info_autoscale_profile_capacity_minimum" {
  type = string
  description = "VMSS Autoscaling Profile Capacity Minimum"
}

variable "res_autoscale_info_autoscale_profile_capacity_maximum" {
  type = string
  description = "VMSS Autoscaling Profile Capacity Maximum"
}

variable "res_autoscale_profile_info" {
  type = list(object({
    profile_rules_metric_name      = string
    profile_rules_time_grain       = string
    profile_rules_statistic        = string
    profile_rules_time_window      = string
    profile_rules_time_aggregation = string
    profile_rules_operator         = string
    profile_rules_threshold        = number
    profile_rules_direction        = string
    profile_rules_type             = string
    profile_rules_value            = string
    profile_rules_cooldown         = string
  }))
  description = "Virtual Machine Scale Set Info"
}