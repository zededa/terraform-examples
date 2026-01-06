### Brand and models
resource "zedcloud_brand" "demo_brand_px" {
  name        = "ACME"                                                        ###User-defined brand name (identifier) - generic brand
  title       = "ACME Corporation"                                            ###Display name shown in ZEDEDA UI
  origin_type = "ORIGIN_LOCAL"                                                ###ORIGIN_LOCAL | ORIGIN_ZEDEDA

    logo = {
      url = "https://www.acme.com/logo.png"                                   ###Publicly reachable logo URL (PNG/JPG/SVG) to display in ZEDEDA UI
    }
}

###---------------------------Hardware Model------------------------------------------------
resource "zedcloud_brand" "demo_brand_intel" {
  name        = "<Name of Brand>"                                             ###<Name of Brand> (identifier) - Intel
  title       = "<Title of Brand>"                                            ###<Title of Brand> (display name)
  origin_type = "ORIGIN_LOCAL"                                                ###ORIGIN_LOCAL | ORIGIN_ZEDEDA

  logo = {
    url = "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Intel_logo_2023.svg/250px-Intel_logo_2023.svg.png" ###Brand logo URL
  }
}

resource "zedcloud_brand" "demo_brand_dell" {
  name        = "Dell"                                                        ###Brand name (identifier) - Dell                
  title       = "Dell"                                                        ###Brand display title        
  origin_type = "ORIGIN_LOCAL"                                                ###ORIGIN_LOCAL | ORIGIN_ZEDEDA
  logo        = {
    url       = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Dell_logo_2016.svg/120px-Dell_logo_2016.svg.png"
  }
}
###---------------------------This information can be gathered from edge node after install in USB, or in EVE console - command: eve enter debug, then type spec.sh
###---------------------------Ensure your entries with VGA,COM,ETH, USB ... align with model from edge node (spec.sh)
resource "zedcloud_model" "demo_intel_nuc_model" {                            ###Intel NUC model example
  name        = "<YOUR-MODEL-NAME>"                                           ###Model name (identifier)
  title       = "<YOUR-MODEL-TITLE>"                                          ###Model display title
  brand_id    = zedcloud_brand.demo_brand_intel.id                            ###Reference to brand you created before in this case zedcloud_brand.demo_brand_px.id
  origin_type = "ORIGIN_LOCAL"                                                ###ORIGIN_LOCAL | ORIGIN_ZEDEDA
  state       = "SYS_MODEL_STATE_ACTIVE"                                      ###Model enabled/active in inventory
  type        = "AMD64"                                                       ###CPU architecture (AMD64/ARM64, etc.)

  logo = {
    url = "https://<url to public image of the model>"                        ###Model logo URL
  }

  attr = {
    memory  = "16G"                                                           ###Total system memory
    storage = "200G"                                                          ###Total system storage
    Cpus    = "8"                                                             ###CPU cores (as string)
  }

  io_member_list {
    ztype        = "IO_TYPE_HDMI"                                             ###I/O type: HDMI/VGA output
    usage        = "ADAPTER_USAGE_APP_SHARED"                                 ###APP_SHARED = usable by apps
    phylabel     = "VGA"                                                      ###Physical label shown in UI
    logicallabel = "VGA"                                                      ###Logical label shown in UI
    cost         = 0                                                          ###Cost (typically 0 unless used for ordering) higher the value is less preferred
    assigngrp    = ""                                                         ###Assign group (blank = none)

    phyaddrs = {
      Ifname  = "VGA"                                                         ###Interface name (if applicable)
      PciLong = "0000:00:02.0"                                                ###PCI address
    }
  }

  io_member_list {
    ztype        = "IO_TYPE_USB_CONTROLLER"                                   ###I/O type: USB controller
    usage        = "ADAPTER_USAGE_APP_SHARED"                                 ###APP_SHARED
    phylabel     = "USB"                                                      ###Physical label
    assigngrp    = "group"                                                    ###Assign group name
    logicallabel = "USB"                                                      ###Logical label
    cost         = 0                                                          ###Cost

    phyaddrs = {
      Ifname  = "USB"                                                         ###Interface name (if applicable)
      PciLong = "0000:00:01.2"                                                ###PCI address
    }
  }

  io_member_list {
    ztype        = "IO_TYPE_COM"                                              ###I/O type: Serial COM
    phylabel     = "COM1"                                                     ###Physical label
    assigngrp    = "COM1"                                                     ###Assign group name
    logicallabel = "COM1"                                                     ###Logical label
    cost         = 0                                                          ###Cost

    phyaddrs = {
      Ioports = "3f8-3ff"                                                     ###I/O port range
      Irq     = 16                                                            ###IRQ number
      Serial  = "/dev/ttyS0"                                                  ###Linux device path
    }
  }

  io_member_list {
    ztype        = "IO_TYPE_ETH"                                              ###I/O type: Ethernet NIC
    usage        = "ADAPTER_USAGE_MANAGEMENT"                                 ###MANAGEMENT = mgmt uplink
    phylabel     = "eth0"                                                     ###Physical label
    logicallabel = "eth0"                                                     ###Logical label
    cost         = 0                                                          ###Cost
    assigngrp    = "eth0"                                                     ###Assign group name

    usage_policy = {
      FreeUplink = false                                                      ###false = not a free uplink
    }

    phyaddrs = {
      Ifname  = "eth0"                                                        ###Linux ifname
      PciLong = ""                                                            ###PCI address (blank if unknown/not set) ***No required for Ethernet interfaces
    }
  }

  io_member_list {
    ztype        = "IO_TYPE_ETH"                                              ###I/O type: Ethernet NIC
    usage        = "ADAPTER_USAGE_APP_SHARED"                                 ###APP_SHARED = usable by apps
    phylabel     = "eth1"                                                     ###Physical label
    logicallabel = "eth1"                                                     ###Logical label
    cost         = 0                                                          ###Cost
    assigngrp    = "eth1"                                                     ###Assign group name

    usage_policy = {
      FreeUplink = false                                                      ###false = not a free uplink
    }

    phyaddrs = {
      Ifname  = "eth1"                                                        ###Linux ifname
      PciLong = ""                                                            ###PCI address (blank if unknown/not set)
    }
  }
} 

resource "zedcloud_model" "demo_dell_xr5610_model" {                          ### Dell model example
  name          = "Dell-XR5610"
  title         = "Dell-XR5610"
  brand_id      = zedcloud_brand.demo_brand_dell.id
  origin_type   = "ORIGIN_LOCAL"
  state         =  "SYS_MODEL_STATE_ACTIVE"
  type          = "AMD64"
  attr          =  {
    memory      = "64G"
    storage     = "894G"
    Cpus        = "48"
  }
 io_member_list {
      ztype         = "IO_TYPE_HDMI"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "VGA"
      logicallabel  = "VGA"
      cost          = 0
      assigngrp     = ""
      phyaddrs      = { 
        Ifname = "VGA"
        PciLong = "0000:03:00.0" }
    }
  io_member_list {
      ztype        = "IO_TYPE_USB_CONTROLLER"
      usage        = "ADAPTER_USAGE_APP_SHARED"
      phylabel     = "USB"
      assigngrp    = "group30"
      phyaddrs     = { 
        Ifname     = "USB"
        PciLong    = "0000:00:14.0" }
      logicallabel = "USB"
      cost         = 0
    }
  io_member_list {
    ztype     = "IO_TYPE_COM"
    phylabel  = "COM1"
    assigngrp = "COM1"
    phyaddrs = {
      Ioports = "3f8-3ff"
      Irq     = 16
    Serial = "/dev/ttyS0" }
    logicallabel = "COM1"
    cost         = 0
  }
  io_member_list {
    ztype     = "IO_TYPE_COM"
    phylabel  = "COM2"
    assigngrp = "COM2"
    phyaddrs = {
      Ioports = "2f8-2ff"
      Irq     = 17
    Serial = "/dev/ttyS1" }
    logicallabel = "COM2"
    cost         = 0
  }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_MANAGEMENT"
      phylabel      = "eth0"
      logicallabel  = "eth0"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth0"
      phyaddrs      = { 
        Ifname = "eth0"
        PciLong = "" }
    }
   io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_MANAGEMENT"
      phylabel      = "eth1"
      logicallabel  = "eth1"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth1"
      phyaddrs      = { 
        Ifname = "eth1"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_MANAGEMENT"
      phylabel      = "eth2"
      logicallabel  = "eth2"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth2"
      phyaddrs      = { 
        Ifname = "eth2"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth3"
      logicallabel  = "eth3"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth3"
      phyaddrs      = { 
        Ifname = "eth3"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth4"
      logicallabel  = "eth4"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth4"
      phyaddrs      = { 
        Ifname = "eth4"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth5"
      logicallabel  = "eth5"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth5"
      phyaddrs      = { 
        Ifname = "eth5"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth6"
      logicallabel  = "eth6"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth6"
      phyaddrs      = { 
        Ifname = "eth6"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth7"
      logicallabel  = "eth7"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth7"
      phyaddrs      = { 
        Ifname = "eth7"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth8"
      logicallabel  = "eth8"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth8"
      phyaddrs      = { 
        Ifname = "eth8"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth9"
      logicallabel  = "eth9"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth9"
      phyaddrs      = { 
        Ifname = "eth9"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth10"
      logicallabel  = "eth10"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth10"
      phyaddrs      = { 
        Ifname = "eth10"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth11"
      logicallabel  = "eth11"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth11"
      phyaddrs      = { 
        Ifname = "eth11"
        PciLong = "" }
    }
}

###---------------------------------Dell model w/ SR-IOV configuration------------------------------------------------
resource "zedcloud_model" "demo_dell_xr5610_sriov_model" {                    ### Dell model example with SR-IOV
  name          = "Dell-XR5610-SRIOV"
  title         = "Dell-XR5610-SRIOV"
  brand_id      = zedcloud_brand.demo_brand_dell.id
  origin_type   = "ORIGIN_LOCAL"
  state         =  "SYS_MODEL_STATE_ACTIVE"
  type          = "AMD64"
  attr          =  {
    memory      = "64G"
    storage     = "894G"
    Cpus        = "48"
  }
 io_member_list {
      ztype         = "IO_TYPE_HDMI"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "VGA"
      logicallabel  = "VGA"
      cost          = 0
      assigngrp     = ""
      phyaddrs      = { 
        Ifname = "VGA"
        PciLong = "0000:03:00.0" }
    }
  io_member_list {
      ztype        = "IO_TYPE_USB_CONTROLLER"
      usage        = "ADAPTER_USAGE_APP_SHARED"
      phylabel     = "USB"
      assigngrp    = "group30"
      phyaddrs     = { 
        Ifname     = "USB"
        PciLong    = "0000:00:14.0" }
      logicallabel = "USB"
      cost         = 0
    }
  io_member_list {
    ztype     = "IO_TYPE_COM"
    phylabel  = "COM1"
    assigngrp = "COM1"
    phyaddrs = {
      Ioports = "3f8-3ff"
      Irq     = 16
    Serial = "/dev/ttyS0" }
    logicallabel = "COM1"
    cost         = 0
  }
  io_member_list {
    ztype     = "IO_TYPE_COM"
    phylabel  = "COM2"
    assigngrp = "COM2"
    phyaddrs = {
      Ioports = "2f8-2ff"
      Irq     = 17
    Serial = "/dev/ttyS1" }
    logicallabel = "COM2"
    cost         = 0
  }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_MANAGEMENT"
      phylabel      = "eth0"
      logicallabel  = "eth0"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth0"
      phyaddrs      = { 
        Ifname = "eth0"
        PciLong = "" }
    }
  io_member_list {
    ztype        = "IO_TYPE_ETH_PF"                                           ### ZTYPE 11
    usage        = "ADAPTER_USAGE_APP_SHARED"
    phylabel     = "eth1"
    logicallabel = "eth1"
    assigngrp    = "eth1"                                                     ### must be unique

    phyaddrs = {
      Ifname  = "eth1"
      PciLong = "0000:17:00.1"                                                ### REQUIRED
    }
    vfs {
      count = 2                                                               ### number of VFs to create
    }
    cost = 0
  }
  io_member_list {
    ztype        = "IO_TYPE_ETH_PF"                                          ### ZTYPE 11
    usage        = "ADAPTER_USAGE_APP_SHARED"
    phylabel     = "eth2"
    logicallabel = "eth2"
    assigngrp    = "eth2"                                                    ### must be unique

    phyaddrs = {
      Ifname  = "eth2"
      PciLong = "0000:17:00.2"                                               ### REQUIRED
    }
    vfs {
      count = 2                                                              ### number of VFs
    }
    cost = 0
  }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth3"
      logicallabel  = "eth3"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth3"
      phyaddrs      = { 
        Ifname = "eth3"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth4"
      logicallabel  = "eth4"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth4"
      phyaddrs      = { 
        Ifname = "eth4"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth5"
      logicallabel  = "eth5"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth5"
      phyaddrs      = { 
        Ifname = "eth5"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth6"
      logicallabel  = "eth6"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth6"
      phyaddrs      = { 
        Ifname = "eth6"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth7"
      logicallabel  = "eth7"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth7"
      phyaddrs      = { 
        Ifname = "eth7"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth8"
      logicallabel  = "eth8"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth8"
      phyaddrs      = { 
        Ifname = "eth8"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth9"
      logicallabel  = "eth9"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth9"
      phyaddrs      = { 
        Ifname = "eth9"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth10"
      logicallabel  = "eth10"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth10"
      phyaddrs      = { 
        Ifname = "eth10"
        PciLong = "" }
    }
  io_member_list {
      ztype         = "IO_TYPE_ETH"
      usage         = "ADAPTER_USAGE_APP_SHARED"
      phylabel      = "eth11"
      logicallabel  = "eth11"
      usage_policy   = {
        FreeUplink = false
      }
      cost          = 0
      assigngrp     = "eth11"
      phyaddrs      = { 
        Ifname = "eth11"
        PciLong = "" }
    }
}


