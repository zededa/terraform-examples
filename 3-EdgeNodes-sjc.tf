####----------------------------------------Edge Node Creation
### Should match the models IO and adapter layout. Pci addresses can be gathered from spec.sh or EVE console
resource "zedcloud_model" "demo_intel_nuc_xxxxx" {        ###Intel NUC model example
  name        = "<Name of Model>"                         ###<Name of Model> (identifier)
  title       = "<Title of Model>"                        ###<Title of Model> (display name)
  brand_id    = zedcloud_brand.demo_brand_intel.id        ###Reference to Intel brand
  origin_type = "ORIGIN_LOCAL"                            ###ORIGIN_LOCAL | ORIGIN_ZEDEDA
  state       = "SYS_MODEL_STATE_ACTIVE"                  ###Model state
  type        = "AMD64"                                   ###CPU architecture

  attr = {
    memory  = "<Amount of System Memory>"                 ###e.g. 32G
    storage = "<Amount of System Storage>"                ###e.g. 256G
    Cpus    = "<Number of CPU Cores>"                     ###e.g. 12
  }

  io_member_list {
    ztype        = "IO_TYPE_HDMI"                          ###HDMI / VGA output
    usage        = "ADAPTER_USAGE_APP_SHARED"              ###App-shared
    phylabel     = "VGA"                                   ###Physical label
    logicallabel = "VGA"                                   ###Logical label
    cost         = 0                                       ###Cost
    assigngrp    = ""                                      ###Assign group

    phyaddrs = {
      Ifname  = "VGA"                                      ###Interface name
      PciLong = "0000:00:02.0"                             ###PCI address
    }
  }

  io_member_list {
    ztype        = "IO_TYPE_USB_CONTROLLER"                ###USB controller
    usage        = "ADAPTER_USAGE_APP_SHARED"              ###App-shared
    phylabel     = "USB"                                   ###Physical label
    logicallabel = "USB"                                   ###Logical label
    assigngrp    = "<USB Assign Group>"                    ###Assign group
    cost         = 0                                       ###Cost - Lowest priority is preferred (In context of which management interface to use first and so on)

    phyaddrs = {
      Ifname  = "USB"                                      ###Interface name
      PciLong = "0000:00:14.0"                             ###PCI address
    }
  }

  io_member_list {
    ztype        = "IO_TYPE_USB_CONTROLLER"                ###USB controller
    usage        = "ADAPTER_USAGE_APP_SHARED"              ###App-shared
    phylabel     = "USB1"                                  ###Physical label
    logicallabel = "USB1"                                  ###Logical label
    assigngrp    = "<USB1 Assign Group>"                   ###Assign group
    cost         = 0                                       ###Cost

    phyaddrs = {
      Ifname  = "USB1"                                     ###Interface name
      PciLong = "0000:3b:00.0"                             ###PCI address
    }
  }

  io_member_list {
    ztype        = "IO_TYPE_ETH"                            ###Ethernet NIC
    usage        = "ADAPTER_USAGE_MANAGEMENT"               ###Management interface
    phylabel     = "eth0"                                   ###Physical label
    logicallabel = "eth0"                                   ###Logical label
    assigngrp    = "eth0"                                   ###Assign group
    cost         = 0                                        ###Cost

    usage_policy = {
      FreeUplink = false                                    ###Not a free uplink
    }

    phyaddrs = {
      Ifname  = "eth0"                                      ###Interface name
      PciLong = ""                                          ###PCI address (optional)
    }
  }

  io_member_list {
    ztype        = "IO_TYPE_ETH"                            ###Ethernet NIC
    usage        = "ADAPTER_USAGE_APP_SHARED"               ###App-shared
    phylabel     = "eth1"                                   ###Physical label
    logicallabel = "eth1"                                   ###Logical label
    assigngrp    = "eth1"                                   ###Assign group
    cost         = 0                                        ###Cost

    usage_policy = {
      FreeUplink = false                                    ###Not a free uplink
    }

    phyaddrs = {
      Ifname  = "eth1"                                      ###Interface name
      PciLong = ""                                          ###PCI address (optional)
    }
  }

  io_member_list {
    ztype        = "IO_TYPE_WLAN"                           ###Wireless NIC
    usage        = "ADAPTER_USAGE_APP_SHARED"               ###App-shared
    phylabel     = "wlan0"                                  ###Physical label
    logicallabel = "wlan0"                                  ###Logical label
    assigngrp    = "<WLAN Assign Group>"                    ###Assign group
    cost         = 0                                        ###Cost

    usage_policy = {
      FreeUplink = false                                    ###Not a free uplink
    }

    phyaddrs = {
      Ifname  = "wlan0"                                    ###Interface name
      PciLong = ""                                         ###PCI address (optional)
    }
  }

  io_member_list {
    ztype        = "IO_TYPE_AUDIO"                          ###Audio device
    phylabel     = "Audio"                                  ###Physical label
    logicallabel = "Audio"                                  ###Logical label
    assigngrp    = "<Audio Assign Group>"                   ###Assign group
    cost         = 0                                        ###Cost

    phyaddrs = {}                                           ###No PCI mapping required
  }
}


resource "zedcloud_edgenode" "demo_dell_node_xr5610" {                    ###Terraform resource name
  model_id       = "<model must have been already created>"               ###Reference to Edge Node model
  name           = "<Name of Edge Node>"                                  ###<Name of Edge Node> (identifier)
  title          = "<Title of Edge Node>"                                 ###<Title of Edge Node> (display name)
  project_id     = zedcloud_project.demo_zededa_project_1.id              ###Reference to project
  onboarding_key = "<Onboarding Key>"                                     ###<Onboarding Key>
  serialno       = "<Serial Number>"                                      ###<Serial Number>
  description    = "<Edge Node Description>"                              ###<Edge Node Description>
  admin_state    = "ADMIN_STATE_ACTIVE"                                   ###Admin state

  ### --------------------
  ### Debug / system config
  ### --------------------
  config_item {
    key          = "debug.enable.ssh"                                     ###Enable SSH
    string_value = var.ssh_pub_key                                        ###SSH public key variable will be in variables.tf
    bool_value   = false
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
  }

  config_item {
    key           = "debug.disable.dhcp.all-ones.netmask"                 ###Disable DHCP all-ones netmask
    string_value  = true
    bool_value    = false
    float_value   = 0
    uint32_value  = 0
    uint64_value  = 0
  }

  config_item {
    key          = "debug.enable.console"                                 ###Enable serial console
    string_value = true
    bool_value   = true
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
  }

  config_item {
    key           = "debug.enable.vga"                                    ###Enable VGA
    string_value  = true
    bool_value    = true
    float_value   = 0
    uint32_value  = 0
    uint64_value  = 0
  }

  config_item {
    key           = "debug.enable.usb"                                    ###Enable USB
    string_value  = true
    bool_value    = true
    float_value   = 0
    uint32_value  = 0
    uint64_value  = 0
  }

  config_item {
    key          = "process.cloud-init.multipart"                         ###Enable multipart cloud-init
    string_value = "true"
    bool_value   = true
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
  }

  ### --------------------
  ### EdgeView configuration
  ### --------------------
  edgeviewconfig {
    generation_id = 0                                                     ###Generation ID
    token         = "<EdgeView Token>"                                    ###<EdgeView Token>

    app_policy {
      allow_app = true                                                    ###Allow app access
    }

    dev_policy {
      allow_dev = true                                                    ###Allow device access
    }

    ext_policy {
      allow_ext = true                                                    ###Allow external access
    }

    jwt_info {
      allow_sec  = 18000                                                  ###Allowed seconds
      disp_url   = "zedcloud.odin.zededa.dev/api/v1/edge-view"            ###EdgeView URL
      encrypt    = true                                                   ###Encrypt JWT
      expire_sec = "0"                                                    ###Expiry
      num_inst   = 3                                                      ###Number of instances
    }
  }

  ### --------------------
  ### Interface bindings
  ### --------------------
  interfaces {
    cost       = 0                                                        ###Cost
    intf_usage = "ADAPTER_USAGE_APP_SHARED"                               ###App-shared
    intfname   = "COM1"                                                   ###Interface name
    tags       = {}                                                       ###Tags
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "COM2"
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "USB"
    netname    = ""
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_MANAGEMENT"                               ###Management interface
    intfname   = "eth0"
    netname    = zedcloud_network.demo_eve_net_port.name                  ###Network created previously zedcloud_network.demo_eve_net_port.name in first 1-infra-sjc.tf
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth1"
    netname    = ""
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth2"
    netname    = ""
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_MANAGEMENT"                               ###Secondary management
    intfname   = "eth3"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth4"
    netname    = zedcloud_network.demo_eve_net_port.name                  ###Tierciary management
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth5"
    netname    = zedcloud_network.demo_eve_net_port.name                  ###..... management    
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth6"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth7"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth8"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth9"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth10"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth11"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "VGA"
    tags       = {}
  }
}


resource "zedcloud_edgenode" "demo_dell_node_xr5610_sriov" {               ###Terraform resource name
  model_id       = "<model must have been already created>"               ###Reference to Edge Node model
  name           = "<Name of Edge Node>"                                  ###<Name of Edge Node> (identifier)
  title          = "<Title of Edge Node>"                                 ###<Title of Edge Node> (display name)
  project_id     = zedcloud_project.demo_zededa_project_1.id              ###Reference to project
  onboarding_key = "<Onboarding Key>"                                     ###<Onboarding Key>
  serialno       = "<Serial Number>"                                      ###<Serial Number>
  description    = "<Edge Node Description>"                              ###<Edge Node Description>
  admin_state    = "ADMIN_STATE_ACTIVE"                                   ###Admin state

  ### --------------------
  ### Debug / system config
  ### --------------------
  config_item {
    key          = "debug.enable.ssh"                                     ###Enable SSH
    string_value = var.ssh_pub_key                                        ###SSH public key variable will be in variables.tf
    bool_value   = false
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
  }

  config_item {
    key           = "debug.disable.dhcp.all-ones.netmask"                 ###Disable DHCP all-ones netmask
    string_value  = true
    bool_value    = false
    float_value   = 0
    uint32_value  = 0
    uint64_value  = 0
  }

  config_item {
    key          = "debug.enable.console"                                 ###Enable serial console
    string_value = true
    bool_value   = true
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
  }

  config_item {
    key           = "debug.enable.vga"                                    ###Enable VGA
    string_value  = true
    bool_value    = true
    float_value   = 0
    uint32_value  = 0
    uint64_value  = 0
  }

  config_item {
    key           = "debug.enable.usb"                                    ###Enable USB
    string_value  = true
    bool_value    = true
    float_value   = 0
    uint32_value  = 0
    uint64_value  = 0
  }

  config_item {
    key          = "process.cloud-init.multipart"                         ###Enable multipart cloud-init
    string_value = "true"
    bool_value   = true
    float_value  = 0
    uint32_value = 0
    uint64_value = 0
  }

  ### --------------------
  ### EdgeView configuration
  ### --------------------
  edgeviewconfig {
    generation_id = 0                                                     ###Generation ID
    token         = "<EdgeView Token>"                                    ###<EdgeView Token>

    app_policy {
      allow_app = true                                                    ###Allow app access
    }

    dev_policy {
      allow_dev = true                                                    ###Allow device access
    }

    ext_policy {
      allow_ext = true                                                    ###Allow external access
    }

    jwt_info {
      allow_sec  = 18000                                                  ###Allowed seconds
      disp_url   = "zedcloud.odin.zededa.dev/api/v1/edge-view"            ###EdgeView URL
      encrypt    = true                                                   ###Encrypt JWT
      expire_sec = "0"                                                    ###Expiry
      num_inst   = 3                                                      ###Number of instances
    }
  }

  ### --------------------
  ### Interface bindings
  ### --------------------
  interfaces {
    cost       = 0                                                        ###Cost
    intf_usage = "ADAPTER_USAGE_APP_SHARED"                               ###App-shared
    intfname   = "COM1"                                                   ###Interface name
    tags       = {}                                                       ###Tags
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "COM2"
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "USB"
    netname    = ""
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_MANAGEMENT"                               ###Management interface
    intfname   = "eth0"
    netname    = zedcloud_network.demo_eve_net_port.name                  ###Network created previously zedcloud_network.demo_eve_net_port.name in first 1-infra-sjc.tf
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth1"
    netname    = ""
    tags       = {}
  }

  interfaces {
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth1vf0"
    netname    = ""
    tags       = {}
  }

  interfaces {
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth1vf1"
    netname    = ""
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth2"
    netname    = ""
    tags       = {}
  }

  interfaces {
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth2vf0"
    netname    = ""
    tags       = {}
  }

  interfaces {
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth2vf1"
    netname    = ""
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_MANAGEMENT"                               ###Secondary management
    intfname   = "eth3"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth4"
    netname    = zedcloud_network.demo_eve_net_port.name                  ###Tierciary management
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth5"
    netname    = zedcloud_network.demo_eve_net_port.name                  ###..... management    
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth6"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth7"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth8"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth9"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth10"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "eth11"
    netname    = zedcloud_network.demo_eve_net_port.name
    tags       = {}
  }

  interfaces {
    cost       = 0
    intf_usage = "ADAPTER_USAGE_APP_SHARED"
    intfname   = "VGA"
    tags       = {}
  }
}


