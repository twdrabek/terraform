variable "NAME" {
  type = string
  description = "(Required) The name of the VM within Proxmox."
  require = true
}
variable "TARGET_NODE" {
  type = string
  description = "(Required) The name of the Proxmox Node on which to place the VM."
  require = true
}
variable "VMID" {
  type = number
  description = "The ID of the VM in Proxmox. The default value of 0 indicates it should use the next available ID in the sequence."
  default = 0
}
variable "DESC" {
  type = string
  description = "The description of the VM. Shows as the 'Notes' field in the Proxmox GUI."
}
variable "DEFINE_CONNECTION_INFO" {
  type = bool
  description = "Whether to let terraform define the (SSH) connection parameters for preprovisioners, see config block below."
  default = true
}
variable "BIOS" {
  type = string
  description = "The BIOS to use, options are seabios or ovmf for UEFI."
  default = "seabios"
}
variable "ONBOOT" {
  type = bool
  description = "Whether to have the VM startup after the PVE node starts."
  default = false
}
variable "STARTUP" {
  type = string
  description = "The startup and shutdown behaviour."
  default = ""
}
variable "VM_STATE" {
  type = string
  description = "The desired state of the VM, options are running or stopped."
  default = "running"
}
variable "ONCREATE" {
  type = bool
  description = "Whether to have the VM startup after the VM is created (deprecated, use vm_state instead)"
  default = true
}
variable "TABLET" {
  type = bool
  description = "Enable/disable the USB tablet device. This device is usually needed to allow absolute mouse positioning with VNC."
  default = true
}
variable "BOOT" {
  type = string
  description = "The boot order for the VM. For example: order=scsi0;ide2;net0. The deprecated legacy= syntax is no longer supported. See the boot option in the Proxmox manual for more information."
}
variable "BOOTDISK" {
  type = string
  description = "Enable booting from specified disk. You shouldn't need to change it under most circumstances."
}
variable "AGENT" {
  type = number
  description = "Set to 1 to enable the QEMU Guest Agent. Note, you must run the qemu-guest-agent daemon in the guest for this to have any effect."
  default = 0
}
variable "ISO" {
  type = string
  description = "The name of the ISO image to mount to the VM in the format: [storage pool]:iso/[name of iso file]. Only applies when clone is not set. Either clone or iso needs to be set. Note that iso is mutually exclussive with clone and pxe modes."
}
variable "PXE" {
  type = bool
  description = "If set to true, enable PXE boot of the VM. Also requires a boot order be set with Network included (eg boot = "order=scsi0;net0"). Note that pxe is mutually exclusive with iso and clone modes."
  default = false
}
variable "CLONE" {
  type = string
  description = "The base VM from which to clone to create the new VM. Note that clone is mutually exclussive with pxe and iso modes."
}
variable "FULL_CLONE" {
  type = bool
  description = "Set to true to create a full clone, or false to create a linked clone. See the docs about cloning for more info. Only applies when clone is set."
}
variable "HASTATE" {
  type = string
  description = "Requested HA state for the resource. One of "started", "stopped", "enabled", "disabled", or "ignored". See the docs about HA for more info."
}
variable "HAGROUP" {
  type = string
  description = "The HA group identifier the resource belongs to (requires hastate to be set!). See the docs about HA for more info."
}
variable "QEMU_OS" {
  type = string
  description = "The type of OS in the guest. Set properly to allow Proxmox to enable optimizations for the appropriate guest OS. It takes the value from the source template and ignore any changes to resource configuration parameter."
  default = "l26"
}
variable "MEMORY" {
  type = number
  description = "The amount of memory to allocate to the VM in Megabytes."
  default = 512
}
variable "BALLOON" {
  type = number
  description = "The minimum amount of memory to allocate to the VM in Megabytes, when Automatic Memory Allocation is desired. Proxmox will enable a balloon device on the guest to manage dynamic allocation. See the docs about memory for more info."
  default = 0
}
variable "SOCKETS" {
  type = number
  description = "The number of CPU sockets to allocate to the VM."
  default = 1
}
variable "CORES" {
  type = number
  description = "The number of CPU cores per CPU socket to allocate to the VM."
  default = !
}
variable "VCPUS" {
  type = number
  description = "The number of vCPUs plugged into the VM when it starts. If 0, this is set automatically by Proxmox to sockets * cores."
  default = 0 
}
variable "CPU" {
  type = string
  description = "The type of CPU to emulate in the Guest. See the docs about CPU Types for more info."
  default = "host"
}
variable "NUMA" {
  type = bool
  description = "Whether to enable Non-Uniform Memory Access in the guest."
  default = false
}
variable "HOTPLUG" {
  type = string
  description = "Comma delimited list of hotplug features to enable. Options: network, disk, cpu, memory, usb. Set to 0 to disable hotplug."
  default = "network,disk,usb"
variable "SCSIHW" {
  type = string
  description = "The SCSI controller to emulate. Options: lsi, lsi53c810, megasas, pvscsi, virtio-scsi-pci, virtio-scsi-single."
  default = "lsi"
}
variable "POOL" {
  type = string
  description = "The resource pool to which the VM will be added."
}
variable "TAGS" {
  type = string
  description = "Tags of the VM. This is only meta information."
}
variable "FORCE_CREATE" {
  type = bool
  description = "If false, and a vm of the same name, on the same node exists, terraform will attempt to reconfigure that VM with these settings. Set to true to always create a new VM (note, the name of the VM must still be unique, otherwise an error will be produced.)"
  default = false
}
variable "OS_TYPE" {
  type = string
  description = "Which provisioning method to use, based on the OS type. Options: ubuntu, centos, cloud-init."
}
variable "FORCE_RECREATE_ON_CHANGE_OF" {
  type = string
  description = "If the value of this string changes, the VM will be recreated. Useful for allowing this resource to be recreated when arbitrary attributes change. An example where this is useful is a cloudinit configuration (as the cicustom attribute points to a file not the content)."
}
variable "OS_NETWORK_CONFIG" {
  type = string
  description = "Only applies when define_connection_info is true. Network configuration to be copied into the VM when preprovisioning ubuntu or centos guests. The specified configuration is added to /etc/network/interfaces for Ubuntu, or /etc/sysconfig/network-scripts/ifcfg-eth0 for CentOS. Forces re-creation on change."
}
variable "SSH_FORWARD_IP" {
  type = string
  description = "Only applies when define_connection_info is true. The IP (and optional colon separated port), to use to connect to the host for preprovisioning. If using cloud-init, this can be left blank."
}
variable "SSH_USER" {
  type = string
  description = "Only applies when define_connection_info is true. The user with which to connect to the guest for preprovisioning. Forces re-creation on change."
}
variable "SSH_PRIVATE_KEY" {
  type = string
  description = "Only applies when define_connection_info is true. The private key to use when connecting to the guest for preprovisioning. Sensitive."
}
variable "CI_WAIT" {
  type = number
  description = "How to long in seconds to wait for before provisioning."
}
variable "CIUSER" {
  type = string
  description = "Override the default cloud-init user for provisioning."
}
variable "CIPASSWORD" {
  type = string
  description = "Override the default cloud-init user's password. Sensitive."
}
variable "CICUSTOM" {
  type = string
  description = "Instead specifying ciuser, cipasword, etc… you can specify the path to a custom cloud-init config file here. Grants more flexibility in configuring cloud-init."
}
variable "CLOUDINIT_CDROM_STORAGE" {
  type = string
  description = "Set the storage location for the cloud-init drive. Required when specifying cicustom."
}
variable "SEARCHDOMAIN" {
  type = string
  description = "Sets default DNS search domain suffix."
}
variable "NAMESERVER" {
  type = string
  description = "Sets default DNS server for guest."
}
variable "SSHKEYS" {
  type = string
  description = "Newline delimited list of SSH public keys to add to authorized keys file for the cloud-init user."
}
variable "IPCONFIG0" {
  type = string
  description = "The first IP address to assign to the guest. Format: [gw=<GatewayIPv4>] [,gw6=<GatewayIPv6>] [,ip=<IPv4Format/CIDR>] [,ip6=<IPv6Format/CIDR>]."
}
variable "IPCONFIG1" {
  type = string
  description = "The second IP address to assign to the guest. Same format as ipconfig0."
}
variable "AUTOMATIC_REBOOT" {
  type = bool
  description = "Automatically reboot the VM when parameter changes require this. If disabled the provider will emit a warning when the VM needs to be rebooted."
  default = true
}
{% comment %} 
VGA Block

The vga block is used to configure the display device. It may be specified multiple times, however only the first instance of the block will be used.
{% endcomment %}
variable "VGA_TYPE" {
  type = string
  description = "The type of display to virtualize. Options: cirrus, none, qxl, qxl2, qxl3, qxl4, serial0, serial1, serial2, serial3, std, virtio, vmware."
  default = "std"
}
variable "VGA_MEMORY" {
  type = number
  description = "Sets the VGA memory (in MiB). Has no effect with serial display type."
}
{% comment %}
Network Block

The network block is used to configure the network devices. It may be specified multiple times. The order in which the blocks are specified determines the ID for each net device. i.e. The first network block will become net0, the second will be net1 etc…

See the docs about network devices for more details.
{% endcomment %}
variable "NETWORK_MODEL" {
  type = string
  description = "Required Network Card Model. The virtio model provides the best performance with very low CPU overhead. If your guest does not support this driver, it is usually best to use e1000. Options: e1000, e1000-82540em, e1000-82544gc, e1000-82545em, i82551, i82557b, i82559er, ne2k_isa, ne2k_pci, pcnet, rtl8139, virtio, vmxnet3."
}
variable "NETWORK_MACADDR" {
  type = string
  description = "Override the randomly generated MAC Address for the VM. Requires the MAC Address be Unicast."
}
variable "NETWORK_BRIDGE" {
  type = string
  description = "Bridge to which the network device should be attached. The Proxmox VE standard bridge is called vmbr0."
  default = "nat"
}
variable "NETWORK_TAG" {
  type = number
  description = "The VLAN tag to apply to packets on this device. -1 disables VLAN tagging."
  default = -1
}
variable "NETWORK_FIREWALL" {
  type = bool
  description = "Whether to enable the Proxmox firewall on this network device."
  default = false
}
variable "NETWORK_RATE" {
  type = number
  description = "Network device rate limit in mbps (megabytes per second) as floating point number. Set to 0 to disable rate limiting."
  default = 0
}
variable "NETWORK_QUEUES" {
  type = number
  description = "Number of packet queues to be used on the device. Requires virtio model to have an effect."
  default = 1
}
variable "NETWORK_LINK_DOWN" {
  type = bool
  description = "Whether this interface should be disconnected (like pulling the plug)."
  default = false
}
