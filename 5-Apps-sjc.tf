###---------------------------------------------Marketplace Application Definitions ---------------------------------------------
resource "zedcloud_application" "app_definition_1" {                    ### VM Example
  name     = "<YOUR-APPLICATION-NAME>"                                  ###User-defined application name
  title    = "<YOUR-APPLICATION-TITLE>"                                 ###Display name shown in ZEDEDA UI
  networks = 1                                                          ###Number of network interfaces exposed by the application

  manifest {
    ac_kind    = "VMManifest"                                           ###VMManifest | ContainerManifest
    ac_version = "1.2.0"                                                ###Manifest schema version
    name       = "<YOUR-APPLICATION-NAME>"                              ###Manifest name

    owner {
      user    = "<your name>"                                            ###Application owner name
      company = "<company>"                                              ###Owning company
      website = "www.<website>.com"                                      ###Company website
      email   = "xxx@xxxx.com"                                           ###Owner contact email
    }

    desc {
      app_category = "APP_CATEGORY_OPERATING_SYSTEM"                     ###High-level application category
      category     = "APP_CATEGORY_OPERATING_SYSTEM"                     ###Detailed application category
      logo = {
        url = "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Ubuntu-logo-2022.svg/250px-Ubuntu-logo-2022.svg.png" ###Application logo URL (Ubuntu example)
      }
    }

    vmmode              = "HV_HVM"                                      ###HV_HVM | HV_PV | HV_PVH
    enablevnc           = true                                          ###Enable VNC console access
    app_type            = "APP_TYPE_VM"                                 ###APP_TYPE_VM | APP_TYPE_CONTAINER
    deployment_type     = "DEPLOYMENT_TYPE_STAND_ALONE"                 ###DEPLOYMENT_TYPE_ STAND_ALONE | CLUSTER
    cpu_pinning_enabled = false                                         ###Enable/disable CPU pinning

    resources {
      name  = "resourceType"                                            ###Resource selector
      value = "custom"                                                  ###custom | standard
    }

    resources {
      name  = "cpus"                                                    ###vCPU allocation
      value = 4                                                         ###4 cpuvexample 
    }

    resources {
      name  = "memory"                                                  ###Memory allocation in KB
      value = 8194304                                                   ###8GB example  
    }

  images {
    imagename   = zedcloud_image.demo_sjc_cisco_image_1.name            ###Referenced image name
    imageid     = zedcloud_image.demo_sjc_cisco_image_1.id              ###Referenced image ID
    imageformat = "QCOW2"                                               ###RAW | QCOW2 | ISO
    cleartext   = false                                                 ###Enable/disable disk encryption
    drvtype     = "HDD"                                                 ###HDD | CDROM
    ignorepurge = true                                                  ###Preserve disk on app delete
    maxsize     = 41943040                                              ###40GB example max size
    readonly    = false                                                 ###Mount drive as read-only
    target      = "Disk"                                                ###Disk | Kernel | Initrd
  }

  interfaces {
    name         = "eth0"                                               ###Interface name (GigabitEthernet1)
    type         = ""                                                   ###Interface type (typically empty)
    directattach = false                                                ###Direct NIC attachment
    privateip    = false                                                ###Private IP assignment

    acls {                                                              ###ACLs apply to workloads (VMs, Containers) that are connecting to a Local type network instance
      matches {
        type  = "ip"                                                    ###ACL match type
        value = "0.0.0.0/0"                                             ###Outbound allow-all rule
      }
    }
  }

  interfaces {
    name         = "eth1"                                              ###Interface name (GigabitEthernet2)
    type         = ""   
    directattach = false
    privateip    = false

    acls {
      matches {
        type  = "ip"
        value = "0.0.0.0/0"                                             ###Outbound allow-all rule
      }
    }
  }

  interfaces {
    name         = "eth2"                                               ###Interface name (GigabitEthernet3)
    type         = ""
    directattach = false
    privateip    = false

    acls {
      matches {
        type  = "ip"
        value = "0.0.0.0/0"                                             ###Outbound allow-all rule
      }
    }
  }

  resources {
    name  = "storage"                                                   ###Storage allocation in KB
    value = 41943040                                                    ###40GB example
  }

  configuration {
    custom_config {
      add      = true                                                   ###Attach custom configuration
      name     = "cloud-config"                                         ###Configuration name
      override = true                                                   ###Override existing config
      template = ""                                                     ###cloud-init or custom config payload
    }
  }
  }

  user_defined_version = "<YOUR-APPLICATION-VERSION>"                   ###User-defined application version
  origin_type          = "ORIGIN_LOCAL"                                 ###ORIGIN_LOCAL | ORIGIN_ZEDEDA
}

###--------------------------------------------- Marketplace Container Definition ---------------------------------------------
resource "zedcloud_application" "app_definition_2_container" {
  name = "<YOUR-APPLICATION-NAME>"                                        ###User-defined application name
  title = "<YOUR-APPLICATION-TITLE>"                                      ###Display name shown in ZEDEDA UI

  manifest {
    ac_kind = "VMManifest"                                                ###VMManifest | ContainerManifest
    ac_version = "1.2.0"                                                  ###Manifest schema version
    name = "<YOUR-APPLICATION-NAME>"                                      ###Manifest name

  owner {                                                                 ###Application ownership metadata
    user = "<your name>"                                                  ##Owner name
    company = "<your company>"                                            ###Owning company
    website = "<your website>"                                            ###Company website
    email = "your email@domain.com"                                       ###Contact email
  }

  desc {                                                                  ###Application description metadata
    app_category = "APP_CATEGORY_CLOUD_APPLICATION"                       ###High-level app category
    category = "APP_CATEGORY_UNSPECIFIED"                                 ###Detailed/secondary category
      logo = {                                                            ###Application logo
      url = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Dall-e_3_%28jan_%2724%29_artificial_intelligence_icon.png/120px-Dall-e_3_%28jan_%2724%29_artificial_intelligence_icon.png" ###Logo URL
    }
  }

  images {
    imagename = zedcloud_image.demo_container_comp_vision_llm_1.name      ###Referenced container image
    cleartext = false                                                     ###Disable cleartext image handling
    ignorepurge = true                                                    ###Preserve image data on delete
    imageformat = "CONTAINER"                                             ###CONTAINER (OCI/Docker image) - CONTAINER
    }

  interfaces {
    name = "eth0"                                                         ###Primary application interface
    type = "ip"                                                           ###Interface type
    directattach = false                                                  ###Do not directly attach physical NIC
    privateip = false                                                     ###Do not force private IP assignment

   acls {
      matches {                                                           ###Outbound ACL rule
        type = "ip"                                                       ###ACL match type
        value = "0.0.0.0/0"                                               ###Allow all outbound traffic
      }
    }
   }

  vmmode = "HV_PV"                                                        ###Paravirtualized mode (containers)
  enablevnc = true                                                        ###Enable VNC console

  resources {
    name = "resourceType"                                                 ###Resource selector
    value = "custom"                                                      ###Custom resource sizing
  }

  resources {
    name = "cpus"                                                         ###CPU allocation
    value = 1                                                             ###1 CPU example
  }

  resources {
    name = "memory"                                                       ###Memory allocation in KB
    value = 2097152                                                       ###2MB example
  }

  configuration {
    custom_config {
      add = true                                                          ###Attach custom configuration
      name = "cloud-config"                                               ###Configuration name
      override = true                                                     ###Override existing configuration
      template = ""                                                       ###Config payload
    }
   }

  app_type = "APP_TYPE_CONTAINER"                                         ###Container application type
  deployment_type = "DEPLOYMENT_TYPE_STAND_ALONE"                         ###Standalone deployment
  cpu_pinning_enabled = false                                             ###Disable CPU pinning
 }

  origin_type = "ORIGIN_LOCAL"                                            ###Local origin
  project_access_list = []                                                ###Projects allowed to use this application
}
