
resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name
  overwrite = true

  source_raw {
    data = templatefile("${path.module}/../scripts/user-data.tftpl", {
      vm_name       = var.vm_name
      ssh_public_key = var.vm_description
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
    import_from  = proxmox_virtual_environment_download_file.latest_ubuntu_22_jammy_qcow2_img.id
    interface    = "scsi0"
    discard      = "on"
    size         = var.disk_size
  }

  initialization {
    datastore_id = "local-lvm"
    ip_config {
      ipv4 {
        address = "dhcp"
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

  boot_order = ["scsi0", "ide2", "net0"]
  tags = var.tags

}

resource "proxmox_virtual_environment_download_file" "latest_ubuntu_22_jammy_qcow2_img" {
  content_type = "import"
  datastore_id = "local"
  node_name    = "pve"
  url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  # need to rename the file to *.qcow2 to indicate the actual file format for import
  file_name = "jammy-server-cloudimg-amd64.qcow2"
  overwrite = true
}


# resource "proxmox_virtual_environment_download_file" "latest_static_ubuntu_24_noble_qcow2_img" {
#   content_type = "import"
#   datastore_id = "local"
#   node_name    = "pve"
#   url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
#   overwrite    = false
# }

# resource "proxmox_virtual_environment_file" "ubuntu_container_template" {
#   content_type = "iso"
#   datastore_id = "local"
#   node_name    = var.node_name

#   source_file {
#     path = "ubuntu-24.04.3-live-server-amd64.iso"
#   }
# }


# resource "random_password" "ubuntu_vm_password" {
#   length           = 16
#   override_special = "_%@"
#   special          = true
# }

# resource "tls_private_key" "ubuntu_vm_key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# output "ubuntu_vm_password" {
#   value     = random_password.ubuntu_vm_password.result
#   sensitive = true
# }

# output "ubuntu_vm_private_key" {
#   value     = tls_private_key.ubuntu_vm_key.private_key_pem
#   sensitive = true
# }

# output "ubuntu_vm_public_key" {
#   value = tls_private_key.ubuntu_vm_key.public_key_openssh
# }
