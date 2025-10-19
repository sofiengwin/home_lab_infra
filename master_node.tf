locals {
  main_control_k3s_install = <<-K3S
    curl -sfL https://get.k3s.io | K3S_TOKEN=775f094564997ff82fbe48901ec92e7f K3S_NODE_NAME=${var.vm_name} sh -
  K3S
}


module "control_node_user_data" {
  source = "./user_data"
  vm_name = var.vm_name
  node_name = var.node_name
  commands = [
    "echo \"done\" > /tmp/cloud-config.done",
    local.main_control_k3s_install
  ]
  files = [
    {
      file_path = "/tmp/cloud.cloud"
      content: "From cloud config"
    }
  ]
  additional_packages = ["vim"]
}

module "control_nodes_module" {
  source = "./vm"
  vm_name = var.vm_name
  node_name = var.node_name
  memory = 4096
  disk_size = 50
  ip_address = var.ip_address
  cloud_config_id = module.control_node_user_data.cloud_config_id
  cloud_image_id = module.cloud_image.cloud_image_id
}

output "vm_ipv4_address" {
  value = module.control_nodes_module.vm_ipv4_address
}

output "cloud_config_id" {
  value = module.control_node_user_data.cloud_config_id
}

variable "node_name" {
  type = string
  default = "pve"
}

variable "vm_name" {
  type = string
  default = "control-node-one"
}

variable "ip_address" {
  type = string
  default = "192.168.1.32"
}