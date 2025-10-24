terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.84.0"
    }
  }
}

resource "proxmox_virtual_environment_download_file" "latest_ubuntu_22_jammy_qcow2_img" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.node_name
  url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  file_name = "jammy-server-cloudimg-amd64.qcow2"
  overwrite = true
}

output "cloud_image_id" {
  value = proxmox_virtual_environment_download_file.latest_ubuntu_22_jammy_qcow2_img.id
}

variable "node_name" {
  type = string
}