location                     = "North europe"
resource_group_name          = "<StudentName>" # Change it to your name
virtual_network_name         = "vnet-vmseries" # Change it 
name_prefix                  = "vmseries-"
inbound_name_prefix          = "inbound-"
outbound_name_prefix         = "outbound-"
outbound_lb_name             = "outbound-private-ilb"
inbound_lb_name              = "inbound-public-elb"
name_scale_set               = "VMSS" # the suffix

tags = {}

address_space = ["10.110.0.0/16"]

network_security_groups = {
  sg_mgmt         = {}
  sg_private      = {}
  sg_pub_inbound  = {}
  sg_pub_outbound = {}
}

allow_inbound_mgmt_ips = [
  "0.0.0.0/0", # Don't change it
]

allow_inbound_data_ips = []

route_tables = {
  private_route_table_inbound = {
    routes = {
      default = {
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.110.1.1"
      }
    }
  }
}

subnets = {
  "management" = {
    address_prefixes       = ["10.110.255.0/24"]
    network_security_group = "sg_mgmt"
  },
  "outbound_private" = {
    address_prefixes       = ["10.110.0.0/24"]
    network_security_group = "sg_private"
  },
  "inbound_private" = {
    address_prefixes       = ["10.110.1.0/24"] # optional subnet
    network_security_group = "sg_private"
  },
  "outbound_public" = {
    address_prefixes       = ["10.110.129.0/24"]
    network_security_group = "sg_pub_outbound"
  },
  "inbound_public" = {
    address_prefixes       = ["10.110.130.0/24"] # optional subnet
    network_security_group = "sg_pub_inbound"
  },
}

public_frontend_ips = {
  frontend01 = {
    create_public_ip = true
    rules = {
      balancehttp = {
        port     = 80
        protocol = "Tcp"
      }
      balancessh = {
        port     = 22
        protocol = "Tcp"
      }
    }
  }
}

olb_private_ip = "10.110.0.21"

inbound_vmseries_version  = "10.2.1"
inbound_vmseries_vm_size  = "Standard_D3_v2"
common_vmseries_sku       = "byol"

inbound_count_minimum  = 2
inbound_count_maximum  = 5


autoscale_metrics = {
  "DataPlaneCPUUtilizationPct" = {
    scaleout_threshold = 15 # 80% is an optimal value
    scalein_threshold  = 5 # 20% is an optimal value
  }
  "panSessionUtilization" = {
    scaleout_threshold = 15 # 80% is an optimal value
    scalein_threshold  = 5 # 20% is an optimal value
  }
  "panSessionThroughputKbps" = {
    scaleout_threshold = 1800 # 1800000  >80 percent of 2.2G
    scalein_threshold  = 400
  }
}

# Autoscaling grows:
scaleout_statistic        = "Average"
scaleout_time_aggregation = "Average"
scaleout_window_minutes   = 2 # 10 is an optimal value
scaleout_cooldown_minutes = 6 # 30 is an optimal value

# Autoscaling shrinks:
scalein_statistic        = "Max"
scalein_time_aggregation = "Average"
scalein_window_minutes   = 60
scalein_cooldown_minutes = 10080

storage_account_name        = "vmssexample20210406"
inbound_storage_share_name  = "ibbootstrapshare"

inbound_files = {
  "inbound_files/init-cfg.txt" = "config/init-cfg.txt"
}