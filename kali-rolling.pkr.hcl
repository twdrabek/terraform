packer {
  required_plugins {
    name = {
      version = ">= 1.1.7"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "kali-rolling-lab" {
  /*
    # Web Application Hacking Lab
    ## Kali Linux Packer Builder
  */
  iso_checksum = "sha256:c150608cad5f8ec71608d0713d487a563d9b916a0199b1414b6ba09fce788ced"
  iso_url = "https://cdimage.kali.org/kali-2024.1/kali-linux-2024.1-installer-amd64.iso"
  iso_storage_pool = var.ISO_STORAGE_POOL

  /*
    ### Connection Settings
  */
  proxmox_url = var.PM_API_URL
  insecure_skip_tls_verify = var.PM_TLS_INSECURE
  username = var.PM_USER
  password = var.PM_PASSWORD


  /*
    ### General Settings
  */
  node = "pve"
  pool = "Lab_Kali"
  vm_name = "kali"
  vm_id = 200
  tags = "student;lab;kali;attack;disposable"
  onboot = false

  /*
    ### OS Settings
  */
  os = "l26"
  disable_kvm = false

  /*
    ### System Settings
  */
  vga {
    type = "std"
    memory = "32"
  }
  bios = "seabios"
  machine = "q35"
  qemu_agent = true

  /*
    ### Disk Settings
  */
  scsi_controller = "virtio-scsi-single"
  disks {
    type = "scsi"
    disk_size = "25G"
    storage_pool = "Mass"
    format = "qcow2"
  }

  /*
    ### CPU Settings
  */
  sockets = 2
  cores = 2
  cpu_type = "x86-64-v2-AES"

  /*
    ### Memory Settings
  */
  memory = 4096
  ballooning_minimum = 2048

  /*
    ### Network Settings
  */
  network_adapters {
      model = "virtio"
      bridge = "vmbr0"
      firewall = true
    }
  // nameserver = 
  // searchdomain = 

  /*
    ### Cloud-Init Settings

    cloud_init (bool) - If true, add an empty Cloud-Init CDROM drive after the virtual
      machine has been converted to a template. Defaults to false.

    cloud_init_storage_pool (string) - Name of the Proxmox storage pool to store the
      Cloud-Init CDROM on. If not given, the storage pool of the boot device will be used.

    qemu_additional_args (string) - Arbitrary arguments passed to KVM. For example -no-reboot
      -smbios type=0,vendor=FOO. Note: this option is for experts only.
  */
  // cloud_init = 
  cloud_init_storage_pool = "Lab_Kali"
  // qemu_additional_args =

  /*
    ### Template Settings
  */
  template_name = "Kali-Rolling-Lab"
  template_description = "Kali Rolling for the Web Application Hacking Lab."
  ssh_username = var.SSH_USERNAME

}

/*
20 <enter> # Language
16 <enter> # Location
1 <enter> # Keyboard
kali <enter> # Hostname
drasec.com <enter> # Domain
<enter> # Fullname
h4ndl3 <enter> # Username
toor <enter> # Password
toor <enter> # Confirm Password
2 <enter> # Timezone
1 <enter> # Partitioning
1 <enter> # Disc
1 <enter> # Scheme
12 <enter> # Write changes
1 <enter> # Confirm
1 2 5 6 7 <enter> # Packages
1 <enter> # Install GRUB
2 <enter> # Select HDD
<enter> # Reboot
*/

build {
  sources = [
    "source.proxmox-iso.kali-rolling-lab"
    ]

  provisioner "shell" {
    only = [
    "source.proxmox-iso.kali-rolling-lab"
    ]

    inline = [
      "echo",
      "echo '${var.foo}'",
    ]
  }
    
}