# Create the Resource Group for inbound VM-Series.
resource "azurerm_resource_group" "inbound" {
  count = var.create_resource_group ? 1 : 0

  name     = coalesce(var.resource_group_name, "${var.name_prefix}vmss")
  location = var.location
}

data "azurerm_resource_group" "inbound" {
  count = var.create_resource_group == false ? 1 : 0

  name = var.resource_group_name
}

locals {
  resource_group = var.create_resource_group ? azurerm_resource_group.inbound[0] : data.azurerm_resource_group.inbound[0]
}


# Generate a random password.
resource "random_password" "this" {
  length           = 16
  min_lower        = 16 - 4
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "_%@"
}

# Create the transit network which holds the VM-Series
# (both inbound and outbound ones).
module "vnet" {
  source = "../modules/vnet"

  create_virtual_network = var.create_virtual_network
  virtual_network_name   = var.virtual_network_name
  resource_group_name     = local.resource_group.name
  location                = var.location
  address_space           = var.address_space
  network_security_groups = var.network_security_groups
  route_tables            = var.route_tables
  subnets                 = var.subnets
  tags                    = merge(var.tags, var.panorama_tags, var.vnet_tags)
}

# Allow access from outside to Management interfaces of VM-Series.
resource "azurerm_network_security_rule" "mgmt" {
  name                        = "vmseries-mgmt-allow-inbound"
  resource_group_name         = local.resource_group.name
  network_security_group_name = "sg_mgmt"
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 1000
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefixes     = var.allow_inbound_mgmt_ips
  destination_address_prefix  = "*"
  destination_port_range      = "*"

  depends_on = [module.vnet]
}

### LOAD BALANCERS ###
# Create the inbound load balancer.
module "inbound_lb" {
  source = "../modules/loadbalancer"

  name                              = var.inbound_lb_name
  resource_group_name               = local.resource_group.name
  location                          = var.location
  frontend_ips                      = var.public_frontend_ips
  enable_zones                      = var.enable_zones
  tags                              = merge(var.tags, var.panorama_tags)
  network_security_group_name       = "sg_pub_inbound"
  network_security_allow_source_ips = coalescelist(var.allow_inbound_data_ips, var.allow_inbound_mgmt_ips)
}

# Create the outbound load balancer.
module "outbound_lb" {
  source = "../modules/loadbalancer"

  name                = var.outbound_lb_name
  resource_group_name = local.resource_group.name
  location            = var.location
  enable_zones        = var.enable_zones
  tags                = merge(var.tags, var.panorama_tags)
  frontend_ips = {
    outbound = {
      subnet_id                     = lookup(module.vnet.subnet_ids, "outbound_private", null)
      private_ip_address_allocation = "Static"
      private_ip_address            = var.olb_private_ip
      rules = {
        HA_PORTS = {
          port     = 0
          protocol = "All"
        }
      }
    }
  }
}


### BOOTSTRAPPING ###

# Create File Share and put there files for initial boot of inbound VM-Series.
module "inbound_bootstrap" {
  source = "../modules/bootstrap"

  resource_group_name  = local.resource_group.name
  location             = var.location
  storage_share_name   = var.inbound_storage_share_name
  storage_account_name = var.storage_account_name
  files                = var.inbound_files
}


### SCALE SETS ###

# Create the inbound scale set.
module "inbound_scale_set" {
  source = "../modules/vmss"

  resource_group_name           = local.resource_group.name
  location                      = var.location
  name_prefix                   = var.inbound_name_prefix
  name_scale_set                = var.name_scale_set
  img_sku                       = var.common_vmseries_sku
  img_version                   = var.inbound_vmseries_version
  vm_size                       = var.inbound_vmseries_vm_size
  autoscale_count_default       = var.inbound_count_minimum
  autoscale_count_minimum       = var.inbound_count_minimum
  autoscale_count_maximum       = var.inbound_count_maximum
  autoscale_notification_emails = var.autoscale_notification_emails
  autoscale_metrics             = var.autoscale_metrics
  scaleout_statistic            = var.scaleout_statistic
  scaleout_time_aggregation     = var.scaleout_time_aggregation
  scaleout_window_minutes       = var.scaleout_window_minutes
  scaleout_cooldown_minutes     = var.scaleout_cooldown_minutes
  scalein_statistic             = var.scalein_statistic
  scalein_time_aggregation      = var.scalein_time_aggregation
  scalein_window_minutes        = var.scalein_window_minutes
  scalein_cooldown_minutes      = var.scalein_cooldown_minutes
  username                      = var.username
  password                      = coalesce(var.password, random_password.this.result)
  subnet_mgmt                   = { id = module.vnet.subnet_ids["management"] }
  subnet_private                = { id = module.vnet.subnet_ids["inbound_private"] }
  subnet_public                 = { id = module.vnet.subnet_ids["inbound_public"] }
  bootstrap_storage_account     = module.inbound_bootstrap.storage_account
  bootstrap_share_name          = module.inbound_bootstrap.storage_share.name
  public_backend_pool_id        = module.inbound_lb.backend_pool_id
  private_backend_pool_id       = module.outbound_lb.backend_pool_id
  create_mgmt_pip               = true
  create_public_pip             = true
}
