###---------------------------------------- Create network Instances (for workloads) ----------
resource "zedcloud_network_instance" "demo_network_instance_switch" {
  name  = "<YOUR-NETWORK-INSTANCE>"                             ###User-defined network instance name
  title = "<YOUR-NETWORK-INSTANCE-TITLE>"                       ###Display name shown in ZEDEDA UI

  kind = "NETWORK_INSTANCE_KIND_SWITCH"                         ###NETWORK_INSTANCE_KIND_SWITCH | NETWORK_INSTANCE_KIND_LOCAL (this type is Switch which forwards untagged and L2 tags)

  type = "NETWORK_INSTANCE_DHCP_TYPE_UNSPECIFIED"               ###NETWORK_INSTANCE_DHCP_TYPE_UNSPECIFIED | CLIENT | SERVER | STATIC
                                                                ###(Typically derived from referenced network configuration)

  port = "eth0"                                                 ###Physical port on the EVE device this network instance binds to

  device_id = "<edge node id>"                                  ###Edge node this network instance is attached to refers to an edgenode you create previously in 3-Edge_Nodes.tf

  depends_on = []                                               ###Optional explicit dependencies (usually empty)
}

###------------------------------------------ Network Instance type Local - provides DHCP w/ default gateway to workloads - all traffic egressing the edge node will source nat to the IP of the physical interface - can be EVEs
resource "zedcloud_network_instance" "demo_network_instance_local" {
  name  = "<YOUR-NETWORK-INSTANCE>"                             ###User-defined network instance name
  title = "<YOUR-NETWORK-INSTANCE-TITLE>"                       ###Display name shown in ZEDEDA UI

  kind = "NETWORK_INSTANCE_KIND_LOCAL"                          ###NETWORK_INSTANCE_KIND_LOCAL | NETWORK_INSTANCE_KIND_SWITCH 
  type = "NETWORK_INSTANCE_DHCP_TYPE_V4"                        ###NETWORK_INSTANCE_DHCP_TYPE_V4 | NETWORK_INSTANCE_DHCP_TYPE_V6 | NETWORK_INSTANCE_DHCP_TYPE_V4_V6

  port      = "eth0"                                            ###Physical port this network instance binds to (e.g. eth0, eth1)
  device_id = "<edge node id>"                                  ###Edge node this network instance is attached to

  ip {
    dhcp_range {                                                ###DHCP pool handed out to clients
      start = "10.10.0.20"                                      ###Start IP in DHCP range
      end   = "10.10.0.30"                                      ###End IP in DHCP range
    }

    dns     = ["1.1.1.1"]                                       ###DNS servers provided via DHCP
    domain  = ""                                                ###DNS search domain (optional)
    gateway = "10.10.0.1"                                       ###Default gateway provided via DHCP
    ntp     = "64.246.132.14"                                   ###NTP server provided via DHCP (if supported by client)
    subnet  = "10.10.0.0/24"                                    ###Subnet for this network instance
  }

  depends_on = []                                               ###Ensure device exists before attaching network instance
}
