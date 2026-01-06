#------------------------------------------------------ Application Deployments ------------------------------------------
resource "zedcloud_application_instance" "demo_app_deploy_1" {
  name       = "<YOUR-APPLICATION-INSTANCE-NAME>"                                       ###User-defined application instance name
  title      = "<YOUR-APPLICATION-INSTANCE-TITLE>"                                      ###Display name shown in ZEDEDA UI

  project_id = zedcloud_project.demo_zededa_project_1.id                                ###Project this app instance belongs to - points back to zedcloud_project.demo_zededa_project_1
  app_id     = zedcloud_application.app_definition_1.id                                 ###Referenced application definition - points back to zedcloud_application.app_definition_1
  device_id  = zedcloud_edgenode.demo_dell_node_x.id                                    ###Edge node where the app instance will run - points back to zedcloud_edgenode.demo_dell_node_x

  activate   = true                                                                     ###Automatically activate (deploy) the app instance

  custom_config {
    add                   = true                                                        ###Attach custom configuration to the app instance
    allow_storage_resize  = true                                                        ###Allow storage resize via custom config
    field_delimiter       = ""                                                          ###Delimiter used inside the config template
    name                  = "cloud-config"                                              ###Configuration name (e.g. cloud-init)
    override              = true                                                        ###Override any existing configuration
    template              = base64encode(file("./c-init/vm-1.txt"))     ###Base64-encoded config payload - this is your cloud-init config (local directory ./c-init/)
  }

  drives {
    imagename   = zedcloud_image.demo_sjc_cisco_image_1.name                            ###Image backing this drive
    cleartext   = false                                                                 ###Enable/disable disk encryption
    ignorepurge = true                                                                  ###Preserve disk data on app delete
    maxsize     = 41943040                                                              ###40GB example max size
    preserve    = false                                                                 ###Preserve disk across redeploys
    target      = "Disk"                                                                ###Disk | Kernel | Initrd
    drvtype     = "HDD"                                                                 ###HDD | CDROM
    readonly    = false                                                                 ###Mount drive as read-only
  }

  interfaces {
    intfname             = "eth0"                                                       ###Interface name exposed to the VM
    intforder            = 1                                                            ###Interface order inside the VM
    directattach         = false                                                        ###Direct NIC attachment
    access_vlan_id       = 0                                                            ###Access VLAN ID (0 = untagged)
    default_net_instance = false                                                        ###Mark as default network instance
    ipaddr               = ""                                                           ###Static IP (empty = DHCP)
    macaddr              = ""                                                           ###Custom MAC address (empty = auto)
    netinstname          = zedcloud_network_instance.tf_net_1.name                      ###Bound network instance - points back to zedcloud_network_instance.xxxxxxx when created
    privateip            = false                                                        ###Use private IP addressing
  }

  interfaces {
    intfname             = "eth1"                                                       ###Second VM interface
    intforder            = 2                                                            ###Second Interface in the order
    directattach         = false
    access_vlan_id       = 0
    default_net_instance = false
    ipaddr               = ""
    macaddr              = ""
    netinstname          = zedcloud_network_instance.tf_net_2.name                      ###Bound network instance - points back to zedcloud_network_instance.xxxxxxx when created
    privateip            = false
  }

  interfaces {
    intfname             = "eth2"                                                       ###Third VM interface
    intforder            = 3
    directattach         = false
    access_vlan_id       = 0
    default_net_instance = false
    ipaddr               = ""
    macaddr              = ""
    netinstname          = zedcloud_network_instance.tf_net_3.name                       ###Bound network instance - points back to zedcloud_network_instance.xxxxxxx when created
    privateip            = false
  }
}

###--------------------------------------------------- Container Deployment -----------------------------------------------
resource "zedcloud_application_instance" "deploy_app_1" {

  name        = "<YOUR-APPLICATION-INSTANCE-NAME>"                               ### User-defined application instance name
  title       = "<YOUR-APPLICATION-INSTANCE-TITLE>"                               ### Display name shown in ZEDEDA UI

  project_id  = zedcloud_project.demo_project_zededa_1.id                   ### Project this app instance belongs to - points back to zedcloud_project.demo_project_zededa_1
  app_id      = zedcloud_application.comp_vision_app_1.id                   ### Referenced application definition - points back to zedcloud_application.comp_vision_app_1
  activate    = true                                                        ### Automatically activate the app instance

  custom_config {
    add                  = true                                             ### Attach custom configuration
    allow_storage_resize = true                                             ### Allow storage resize via config
    field_delimiter      = ""                                            ### Delimiter used inside template
    name                 = "cloud-config"                                   ### Configuration name
    override             = true                                             ### Override existing configuration
    template             = base64encode(file("./cinit/container-1.txt"))    ### Base64-encoded config payload
  }
  device_id  = zedcloud_edgenode.demo_edge_node_1.id                        ### Edge node where the app runs

  drives {
    imagename   = zedcloud_image.demo_container_app_1.name                  ### Image backing this drive - points back to zedcloud_image.demo_container_app_1
    cleartext   = false                                                     ### Disable cleartext disk handling
    ignorepurge = true                                                      ### Preserve disk data on delete
    maxsize     = 20971520                                                  ### 20G example max size
    preserve    = false                                                     ### Do not preserve disk across redeploys
    target      = "Disk"                                                    ### Disk | Kernel | Initrd
    drvtype     = "HDD"                                                     ### HDD | CDROM
    readonly    = false                                                     ### Mount drive as read-only
  }

  interfaces {
    intfname             = "eth0"                                           ### Interface name exposed to the app
    directattach         = false                                            ### Do not directly attach physical NIC
    access_vlan_id       = 0                                                ### Access VLAN ID (0 = untagged)
    default_net_instance = false                                            ### Not the default network instance
    intforder            = 0                                                ### Interface order
    ipaddr               = ""                                               ### Static IP (empty = DHCP)
    macaddr              = ""                                               ### Custom MAC address (empty = auto)
    netinstname          = zedcloud_network_instance.demo_network_instance_local.name   ### Bound network instance
    privateip            = false                                            ### Do not force private IP addressing
  }
}
