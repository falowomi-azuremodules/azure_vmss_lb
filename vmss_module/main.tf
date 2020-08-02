module "deploy_vmss_stack" {
  source                                                                  = "../vmss_library"

  req_rg_name                                                             = var.res_rg_name
  req_rg_location                                                         = var.res_rg_location
  req_vnet_info = {
    vnet_name                                                             = var.res_vnet_info.vnet_name
    vnet_address_space                                                    = var.res_vnet_info.vnet_address_space
  }

  req_subnet_info = {
    subnet_name                                                           = var.res_subnet_info.subnet_name
    subnet_address_prefixes                                               = var.res_subnet_info.subnet_address_prefixes
  }

  req_nsg_name                                                            = var.res_nsg_name

  req_nsg_rules_info                                                      = var.res_nsg_rules_info

  req_pip_info = {
    pip_name                                                              = var.res_pip_info.pip_name
    pip_allocation_method                                                 = var.res_pip_info.pip_allocation_method
    pip_domain_name_label                                                 = var.res_pip_info.pip_domain_name_label
  }

  req_load_balancer_info = {
    lb_name                                                               = var.res_load_balancer_info.lb_name
    lb_frontend_ip_config_name                                            = var.res_load_balancer_info.lb_frontend_ip_config_name
    lb_bepool_name                                                        = var.res_load_balancer_info.lb_bepool_name
    lb_hp_name                                                            = var.res_load_balancer_info.lb_hp_name
    lb_hp_protocol                                                        = var.res_load_balancer_info.lb_hp_protocol
    lb_hp_request_path                                                    = var.res_load_balancer_info.lb_hp_request_path
    lb_hp_port                                                            = var.res_load_balancer_info.lb_hp_port
    lb_rule_name                                                          = var.res_load_balancer_info.lb_rule_name
    lb_rule_protocol                                                      = var.res_load_balancer_info.lb_rule_protocol
    lb_rule_frontend_port                                                 = var.res_load_balancer_info.lb_rule_frontend_port
    lb_rule_backend_port                                                  = var.res_load_balancer_info.lb_rule_backend_port
  }

  req_vmss_info = {
    vmss_name                                                             = var.res_vmss_info.vmss_name
    vmss_sku                                                              = var.res_vmss_info.vmss_sku
    vmss_instances                                                        = var.res_vmss_info.vmss_instances
    vmss_admin_username                                                   = var.res_vmss_info.vmss_admin_username
    vmss_admin_password                                                   = var.res_vmss_info.vmss_admin_password
    vmss_disable_password_authentication                                  = var.res_vmss_info.vmss_disable_password_authentication
    vmss_enable_automatic_os_upgrade                                      = var.res_vmss_info.vmss_enable_automatic_os_upgrade
    vmss_disable_automatic_rollback                                       = var.res_vmss_info.vmss_disable_automatic_rollback
    vmss_upgrade_mode                                                     = var.res_vmss_info.vmss_upgrade_mode
    vmss_enabled                                                          = var.res_vmss_info.vmss_enabled
    vmss_max_batch_instance_percent                                       = var.res_vmss_info.vmss_max_batch_instance_percent
    vmss_max_unhealthy_instance_percent                                   = var.res_vmss_info.vmss_max_unhealthy_instance_percent
    vmss_max_unhealthy_upgraded_instance_percent                          = var.res_vmss_info.vmss_max_unhealthy_upgraded_instance_percent
    vmss_pause_time_between_batches                                       = var.res_vmss_info.vmss_pause_time_between_batches
    vmss_instance_publisher                                               = var.res_vmss_info.vmss_instance_publisher
    vmss_instance_offer                                                   = var.res_vmss_info.vmss_instance_offer
    vmss_instance_sku                                                     = var.res_vmss_info.vmss_instance_sku
    vmss_instance_version                                                 = var.res_vmss_info.vmss_instance_version
    vmss_storage_account_type                                             = var.res_vmss_info.vmss_storage_account_type
    vmss_caching                                                          = var.res_vmss_info.vmss_caching
    vmss_nic_name                                                         = var.res_vmss_info.vmss_nic_name
    vmss_nic_primary                                                      = var.res_vmss_info.vmss_nic_primary
    vmss_nic_ipconfig_name                                                = var.res_vmss_info.vmss_nic_ipconfig_name
    vmss_nic_ipconfig_primary                                             = var.res_vmss_info.vmss_nic_ipconfig_primary
    vmss_nic_pip_name                                                     = var.res_vmss_info.vmss_nic_pip_name
    vmss_nic_pip_idle_timeout_in_minutes                                  = var.res_vmss_info.vmss_nic_pip_idle_timeout_in_minutes
    vmss_nic_pip_domain_name_label                                        = var.res_vmss_info.vmss_nic_pip_domain_name_label
  }

  req_autoscale_info = {
    autoscale_name                                                        = var.res_autoscale_info_autoscale_name
    autoscale_profile_name                                                = var.res_autoscale_info_autoscale_profile_name
    autoscale_profile_capacity_default                                    = var.res_autoscale_info_autoscale_profile_capacity_default
    autoscale_profile_capacity_minimum                                    = var.res_autoscale_info_autoscale_profile_capacity_minimum
    autoscale_profile_capacity_maximum                                    = var.res_autoscale_info_autoscale_profile_capacity_maximum
  }

  req_autoscale_profile_info                                              = var.res_autoscale_profile_info
}