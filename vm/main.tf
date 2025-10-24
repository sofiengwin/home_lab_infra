data "local_file" "ssh_public_key" {
  filename = "/Users/godwinogbara/.ssh/homelab.pub"
}
resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name
  overwrite = true

  source_raw {
    data = templatefile("${path.module}/../scripts/user-data.yaml.tftpl", {
      vm_name       = var.vm_name
      ssh_public_key = trimspace(data.local_file.ssh_public_key.content)
      additional_packages = var.additional_packages
      files = var.files
      commands = var.commands
    })

    file_name = format("cloud-config-user-data-%s.yaml", var.vm_name)
  }
}
resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = var.vm_name
  node_name = var.node_name
  description = var.vm_description

  agent {
    enabled = true
  }

  stop_on_destroy = true

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }


  cpu {
    cores = var.cores
    sockets = var.sockets
    type         = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = "local-lvm"
    file_format  = "qcow2"
    import_from  = var.cloud_image_id
    interface    = "scsi0"
    discard      = "on"
    size         = var.disk_size
  }

  initialization {
    datastore_id = "local-lvm"
    dns {
      servers = ["1.1.1.1", "192.168.1.1"]
    }
    ip_config {
      ipv4 {
        address = "${var.ip_address}/24"
        gateway = "192.168.1.1"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
    # mac_address = var.mac_address
  }
  
  operating_system {
    type = "l26"
  }

  tags = var.tags
}

output "vm_ipv4_address" {
  value = proxmox_virtual_environment_vm.ubuntu_vm.ipv4_addresses[1][0]
}
