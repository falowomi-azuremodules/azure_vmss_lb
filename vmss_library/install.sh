#!/bin/bash
apt-get update -y
apt-get -y install apache2 php7.0 libapache2-mod-php7.0
service apache2 start
service apache2 stop


mkdir /site
mkdir /site/main
mkdir /site/main/html

sed -i 's+DocumentRoot /var/www/html+DocumentRoot /site/main/html+g' /etc/apache2/sites-enabled/000-default.conf
sed -i 's+<Directory /var/www>+<Directory /site/main>+g' /etc/apache2/apache2.conf

apachectl configtest

cat <<EOF > /site/main/html/index.php
<?php
\$hostname = gethostname();
echo "<h2>Hello World!</h2>";
echo "<h2>Server Hostname: \$hostname</h2>";
?>
EOF

rm -rf /var/www

service apache2 start










provider "azurerm" {
  version = "2.8.0"
  features {}
}

resource "azurerm_resource_group" "onica_rg" {
  name     = "denis_onica_rg"
  location = "northcentralus"
}

resource "azurerm_virtual_network" "onica_vnet" {
  name                = "denis_onica_vnet"
  address_space       = ["10.254.0.0/16"]
  location            = azurerm_resource_group.onica_rg.location
  resource_group_name = azurerm_resource_group.onica_rg.name
}

resource "azurerm_subnet" "onica_vnet_subnet" {
  name                 = "compute_private_subnet"
  resource_group_name  = azurerm_resource_group.onica_rg.name
  virtual_network_name = azurerm_virtual_network.onica_vnet.name
  address_prefixes     = ["10.254.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "onica_vnet_subnet_association" {
  subnet_id                 = azurerm_subnet.onica_vnet_subnet.id
  network_security_group_id = azurerm_network_security_group.onica_nsg.id
}

resource "azurerm_network_security_group" "onica_nsg" {
  name                = "denis_onica_nsg"
  location            = azurerm_resource_group.onica_rg.location
  resource_group_name = azurerm_resource_group.onica_rg.name

  security_rule {
    name                       = "remote_management_ports"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = [22, 3389]
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.onica_vnet_subnet.address_prefix
  }

  security_rule {
    name                       = "http_to_lb"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_public_ip.onica_public_ip.ip_address
  }

  security_rule {
    name                       = "lb_to_backend"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "ALlow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = azurerm_public_ip.onica_public_ip.ip_address
    destination_address_prefix = azurerm_subnet.onica_vnet_subnet.address_prefix
  }
}

resource "azurerm_public_ip" "onica_public_ip" {
  name                = "loadbalancer_pip"
  location            = azurerm_resource_group.onica_rg.location
  resource_group_name = azurerm_resource_group.onica_rg.name
  allocation_method   = "Static"
  domain_name_label   = "denisonica"
}

resource "azurerm_lb" "onica_lb" {
  name                = "denis_onica_lb"
  location            = azurerm_resource_group.onica_rg.location
  resource_group_name = azurerm_resource_group.onica_rg.name

  frontend_ip_configuration {
    name                 = "lb_frontend_ip_config"
    public_ip_address_id = azurerm_public_ip.onica_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = azurerm_resource_group.onica_rg.name
  loadbalancer_id     = azurerm_lb.onica_lb.id
  name                = "lb_backend_pool"
}


resource "azurerm_lb_probe" "health_probe" {
  resource_group_name = azurerm_resource_group.onica_rg.name
  loadbalancer_id     = azurerm_lb.onica_lb.id
  name                = "http-probe"
  protocol            = "Http"
  request_path        = "/"
  port                = 80
}

resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name            = azurerm_resource_group.onica_rg.name
  loadbalancer_id                = azurerm_lb.onica_lb.id
  name                           = "lb_http_rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "lb_frontend_ip_config"
  probe_id                       = azurerm_lb_probe.health_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
}

resource "azurerm_linux_virtual_machine_scale_set" "onica_vmss" {
  name                            = "denisvmss"
  resource_group_name             = azurerm_resource_group.onica_rg.name
  location                        = azurerm_resource_group.onica_rg.location
  sku                             = "Standard_DS12_v2"
  instances                       = 1
  admin_username                  = "adminuser"
  admin_password                  = "School123$123$"
  disable_password_authentication = false

  automatic_os_upgrade_policy {
    enable_automatic_os_upgrade = true
    disable_automatic_rollback  = false
  }

  upgrade_mode = "Automatic"

  automatic_instance_repair {
    enabled = true
  }

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "vmss_network_profile"
    primary = true

    ip_configuration {
      name                                   = "IPConfig"
      primary                                = true
      subnet_id                              = azurerm_subnet.onica_vnet_subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      public_ip_address {
        name                    = "denis_onica_vmss_pip"
        idle_timeout_in_minutes = 10
        domain_name_label       = "denisazurepiptest"
      }
    }
  }

  health_probe_id = azurerm_lb_probe.health_probe.id

  depends_on = [
    azurerm_lb_rule.lb_rule,
  ]
}

resource "azurerm_template_deployment" "vmss-extension" {
  name                = "${azurerm_linux_virtual_machine_scale_set.onica_vmss.name}-extension"
  resource_group_name = azurerm_resource_group.onica_rg.name

  template_body = file("custom_extension.json")

  parameters = {
    "vmName" = azurerm_linux_virtual_machine_scale_set.onica_vmss.name
  }

  deployment_mode = "Incremental"
}

resource "azurerm_monitor_autoscale_setting" "onica_autoscaling" {
  name                = "denis_onica_autoscaling"
  resource_group_name = azurerm_resource_group.onica_rg.name
  location            = azurerm_resource_group.onica_rg.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.onica_vmss.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 4
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.onica_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.onica_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}

#resource "null_resource" "lunch_site" {
#  provisioner "local-exec" {
#    command = "Start-Process iexplore ${azurerm_public_ip.onica_public_ip.fqdn}"
#    
#    interpreter = ["PowerShell", "-Command"]
#  }
#
#  depends_on = [
#    azurerm_linux_virtual_machine_scale_set.onica_vmss,
#    azurerm_monitor_autoscale_setting.onica_autoscaling,
#    azurerm_template_deployment.vmss-extension,
#  ]
#}