###---------------------------------- Create a project with EdgeView #################
resource "zedcloud_project" "demo_zededa_project_1" {
  name  = "<YOUR-PROJECT-NAME>"                                                   ###User-defined project name
  title = "<YOUR-PROJECT-TITLE>"                                                  ###Display name shown in ZEDEDA UI
  type  = "TAG_TYPE_PROJECT"                                                      ###TAG_TYPE_PROJECT | TAG_TYPE_GENERIC

  tag_level_settings {
    interface_ordering    = "INTERFACE_ORDERING_ENABLED"                          ###INTERFACE_ORDERING_ENABLED | INTERFACE_ORDERING_DISABLED
    flow_log_transmission = "NETWORK_INSTANCE_FLOW_LOG_TRANSMISSION_ENABLED"      ###NETWORK_INSTANCE_FLOW_LOG_TRANSMISSION_ENABLED | DISABLED
  }

  edgeview_policy {                                                               ###Edge-View access policy (project scope)
    type = "POLICY_TYPE_EDGEVIEW"                                                 ###POLICY_TYPE_EDGEVIEW

    edgeview_policy {
      access_allow_change = true                                                  ###true | false
      edgeview_allow      = true                                                  ###true | false

      edgeviewcfg {
        app_policy {
          allow_app = true                                                        ###true | false (app/VM/container access)
        }

        dev_policy {
          allow_dev = true                                                        ###true | false (device/EVE host access)
        }

        jwt_info {
          disp_url  = "zedcloud.gmwtus.zededa.net/api/v1/edge-view"               ###ZEDEDA Edge-View dispatcher endpoint url
          allow_sec = 18000                                                       ###JWT lifetime in seconds (e.g. 3600, 7200, 18000)
          num_inst  = 1                                                           ###Concurrent sessions per JWT (e.g. 1–n)
          encrypt   = true                                                        ###true | false
        }

        ext_policy {
          allow_ext = true                                                        ###true | false (external client access)
        }
      }

      max_expire_sec = 2592000                                                    ###Max Edge-View session duration in seconds
      max_inst       = 3                                                          ###Max concurrent Edge-View sessions
    }
  }
}

####-------------------------------- Create local HTTP datastore---------------------------
resource "zedcloud_datastore" "demo_local_http_ds" {
  ds_fqdn = "http://172.16.8.129"                                                 ###HTTP endpoint hosting images
  ds_type = "DATASTORE_TYPE_HTTP"                                                 ###DATASTORE_TYPE_HTTP

  name  = "<YOUR-HTTP-DS-NAME>"                                                   ###User-defined datastore name
  title = "<YOUR-HTTP-DS-TITLE>"                                                  ###Display name shown in ZEDEDA UI

  ds_path = "iso"                                                                 ###Relative path on HTTP server http://172.16.8.129/iso

  project_access_list = []                                                        ###List of project IDs allowed to access datastore
}

###---------------------------------- Create local HTTPS datastore---------------------------
resource "zedcloud_datastore" "demo_local_https_ds" {
  ds_fqdn = "https://172.16.8.129"                                                ###HTTPS endpoint hosting images
  ds_type = "DATASTORE_TYPE_HTTPS"                                                ###DATASTORE_TYPE_HTTPS

  name  = "<YOUR-HTTP-DS-NAME>"                                                   ###User-defined datastore name
  title = "<YOUR-HTTP-DS-TITLE>"                                                  ###Display name shown in ZEDEDA UI

  ds_path = "iso"                                                                 ###Relative path on HTTPS server https://172.16.8.129/iso

  project_access_list = []                                                        ###List of project IDs allowed to access datastore
}

###------------------------------------ Create Docker Hub registry---------------------------
resource "zedcloud_datastore" "demo_docker_hub" {
  ds_fqdn = "docker://docker.io"                                                  ###Docker Hub registry endpoint
  ds_type = "DATASTORE_TYPE_CONTAINERREGISTRY"                                    ###DATASTORE_TYPE_CONTAINERREGISTRY

  name  = "<YOUR-REGISTRY-NAME>"                                                  ###User-defined registry name (Any name you want to give Docker Hub)
  title = "<YOUR-REGISTRY-TITLE>"                                                 ###Display name shown in ZEDEDA UI

  project_access_list = []                                                        ###List of project IDs allowed to access registry
}

###------------------------------------- EVE OS Images---------------------------
resource "zedcloud_image" "demo_sjc_eve_OS_image_16" {
  name  = "<YOUR-IMAGE-NAME>"                                                     ###User-defined image name - sample is EVE os 16.0.0-rc6-kvm-amd64.img
  title = "<YOUR-IMAGE-TITLE>"                                                    ###Display name shown in ZEDEDA UI
  datastore_id = zedcloud_datastore.demo_local_https_ds.id                        ###ID of datastore hosting the image points to early entry in zedcloud_datastore.demo_local_https_ds
  image_type   = "IMAGE_TYPE_EVE"                                                 ###IMAGE_TYPE_EVE | IMAGE_TYPE_VM | IMAGE_TYPE_CONTAINER
  image_arch   = "AMD64"                                                          ###AMD64 | ARM64
  image_format = "RAW"                                                            ###RAW | QCOW2 | ISO
  image_sha256     = "<256 shasum hash>"                                          ###SHA256 checksum of image file
  image_size_bytes = "<image size in KB>"                                         ###Image size in bytes
  project_access_list = []                                                        ###List of project IDs allowed to use this image
  image_rel_url = "16.0.0-rc6-kvm-amd64.img"                      ###Relative path or filename in datastore (e.g. 16.0.0-rc6-kvm-amd64.img)
}

resource "zedcloud_image" "demo_sjc_eve_OS_image_14" {
  name  = "<YOUR-IMAGE-NAME>"                                                     ###User-defined image name
  title = "<YOUR-IMAGE-TITLE>"                                                    ###Display name shown in ZEDEDA UI

  datastore_id = zedcloud_datastore.demo_local_https_ds.id                        ###ID of datastore hosting the image (references zedcloud_datastore.demo_sjc_ds)

  image_type   = "IMAGE_TYPE_EVE"                                                 ###IMAGE_TYPE_EVE | IMAGE_TYPE_VM | IMAGE_TYPE_CONTAINER
  image_arch   = "AMD64"                                                          ###AMD64 | ARM64
  image_format = "RAW"                                                            ###RAW | QCOW2 | ISO

  image_sha256     = "<256 shasum hash>"                                          ###SHA256 checksum of image file
  image_size_bytes = 123456                                                       ###Image size in bytes

  project_access_list = []                                                        ###List of project IDs allowed to use this image

  image_rel_url = "eve-14.5.2-lts-kvm-amd64.img"                                  ###Relative path or filename in datastore - example with real name of image as its stored in the datastore
}

###-------------------------------------- VM Images-----------------------------------------------------------------------------------------------------------------------
resource "zedcloud_image" "demo_vm_image_1" {
  datastore_id = zedcloud_datastore.demo_sjc_ds.id                                ###ID of datastore hosting the image (references zedcloud_datastore.demo_sjc_ds)
  name  = "<YOUR-IMAGE-NAME>"                                                     ###User-defined image name
  title = "<YOUR-IMAGE-TITLE>"                                                    ###Display name shown in ZEDEDA UI
  image_type   = "IMAGE_TYPE_APPLICATION"                                         ###IMAGE_TYPE_APPLICATION | IMAGE_TYPE_VM | IMAGE_TYPE_CONTAINER
  image_arch   = "AMD64"                                                          ###AMD64 | ARM64
  image_format = "QCOW2"                                                          ###RAW | QCOW2 | ISO

  image_sha256     = "<256 shasum hash>"                                          ###SHA256 checksum of image file
  image_size_bytes = 123456                                                       ###Image size in Kbytes

  project_access_list = []                                                        ###List of project IDs allowed to use this image (can be blank to allow all)

  image_rel_url = "<filename>.qcow2"                                              ###Relative path or filename in datastore - sample if its a qcow2
}

resource "zedcloud_image" "demo_vm_image_2" {
  datastore_id = zedcloud_datastore.demo_sjc_ds.id                                ###ID of datastore hosting the image (references zedcloud_datastore.demo_sjc_ds)
  name  = "<YOUR-IMAGE-NAME>"                                                     ######User-defined image name
  title = "<YOUR-IMAGE-TITLE>"                                                    ###Display name shown in ZEDEDA UI

  image_type   = "IMAGE_TYPE_APPLICATION"                                         ###IMAGE_TYPE_APPLICATION | IMAGE_TYPE_VM | IMAGE_TYPE_CONTAINER
  image_arch   = "AMD64"                                                          ###AMD64 | ARM64
  image_format = "QCOW2"                                                          ###RAW | QCOW2 | ISO

  image_sha256     = "<256 shasum hash>"                                          ###SHA256 checksum of image file
  image_size_bytes = 123456                                                       ###Image size in Kbytes


  project_access_list = []                                                        ###List of project IDs allowed to use this image

  image_rel_url = "<filename>.img"                                                ###Relative path or filename in datastore - sample if its a .img file
}

###--------------------------------------- EVE Container Image ---------------------------
resource "zedcloud_image" "demo_container_app_1" {
  datastore_id = zedcloud_datastore.demo_docker_hub_1.id          ###Container registry datastore hosting the image

  image_type   = "IMAGE_TYPE_APPLICATION"                         ###IMAGE_TYPE_APPLICATION | IMAGE_TYPE_VM | IMAGE_TYPE_CONTAINER
  image_arch   = "AMD64"                                          ###AMD64 | ARM64
  image_format = "CONTAINER"                                      ###CONTAINER (OCI/Docker image)

  image_size_bytes = 0                                            ###Container images do not require a fixed size (set to 0)

  name  = "<YOUR-CONTAINER-IMAGE-NAME>"                           ###User-defined container image name
  title = "<YOUR-CONTAINER-IMAGE-TITLE>"                          ###Display name shown in ZEDEDA UI

  project_access_list = []                                        ###List of projects allowed to use this image

  image_rel_url = "nginx:latest"                                  ###Container image reference (repo:tag) example
}

###------------------ EDGE NODE MANAGEMENT NETWORK - How EVE physically mapped port will behave (This case set to DHCP) ############################################################################################
resource "zedcloud_network" "demo_eve_net_port" {
  name  = "<YOUR-NETWORK-NAME>"                                                   ###User-defined network name
  title = "<YOUR-NETWORK-TITLE>"                                                  ###Display name shown in ZEDEDA UI

  description = "This Network - tells the EVE mgt port how to function (DHCP...)" ###Optional description of network purpose

  enterprise_default = false                                                      ###true | false (set as enterprise-wide default network)

  kind = "NETWORK_KIND_V4"                                                        ###NETWORK_KIND_V4 | NETWORK_KIND_V6 | NETWORK_KIND_V4_V6

  ip {
    dhcp = "NETWORK_DHCP_TYPE_CLIENT"                                             ###NETWORK_DHCP_TYPE_CLIENT | NETWORK_DHCP_TYPE_SERVER | NETWORK_DHCP_TYPE_STATIC
  }

  project_id = zedcloud_project.demo_zededa_project_1.id                          ###Project this network belongs to
}

###--------------------EDGE NODE MANAGEMENT NETWORK - Stativ example
resource "zedcloud_network" "demo_eve_net_port_static" {
  name  = "<YOUR-NETWORK-NAME>"                                                   ###User-defined network name
  title = "<YOUR-NETWORK-TITLE>"                                                  ###Display name shown in ZEDEDA UI

  description = "Static IP configuration for EVE management port"                 ###Optional description of network purpose

  enterprise_default = false                                                      ###true | false (set as enterprise-wide default network)

  kind = "NETWORK_KIND_V4"                                                        ###NETWORK_KIND_V4 | NETWORK_KIND_V6 | NETWORK_KIND_V4_V6

  ip {
    dhcp = "NETWORK_DHCP_TYPE_STATIC"                                             ###NETWORK_DHCP_TYPE_CLIENT | NETWORK_DHCP_TYPE_SERVER | NETWORK_DHCP_TYPE_STATIC

    subnet = "192.168.100.0/24"                                                   ###IPv4 subnet assigned to this network
    gateway = "192.168.100.1"                                                     ###Default gateway for the subnet

    dns = [                              
      "8.8.8.8",                                                                  ###Primary DNS server
      "8.8.4.4"                                                                   ###Secondary DNS server
    ]
  }

  project_id = zedcloud_project.demo_zededa_project_1.id                          ###Project this network belongs to. Example point back to zedcloud_project.demo_zededa_project_1

}
