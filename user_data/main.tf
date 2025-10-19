terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.84.0"
    }
  }
}

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

output "cloud_config_id" {
  value = proxmox_virtual_environment_file.user_data_cloud_config.id
}

variable "vm_name" {
  type = string
}
variable "node_name" {
  type = string
}
variable "additional_packages" {
  type = list(string)
  default = []
}

variable "files" {
  type = list(object({
    file_path = string
    content = string
  }))

  default = []
}

variable "commands" {
  type = list(string)
  default = []
}


    # "curl -sfL https://get.k3s.io | K3S_TOKEN=775f094564997ff82fbe48901ec92e7f K3S_NODE_NAME=${vm_name} sh -",
