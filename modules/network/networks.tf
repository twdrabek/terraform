
# Default network. 

resource "proxmox" "std" {
    netowrk {
        name   = "eth0"
        bridge = "vmbr0"
        ip     = "dhcp"
    }
}

# Secondary network.

resource "proxmox" "sec" {
    network {
        name   = "eth1"
        bridge = "vmbr0"
        ip     = "dhcp"
    }
}
