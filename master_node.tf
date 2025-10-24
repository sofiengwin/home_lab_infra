locals {
  main_master_ip_address = "192.168.1.205"
  main_master_node_name = "pve"
  main_master_vm_name = "control-node-one"

  support_masters = [
    {
      vm_name  = "master-2",
      node_name = "pvelenovo",
      ip_address = "192.168.1.206",
      cloud_image_id = module.pvepfsense_cloud_image.cloud_image_id
    },
    {
      vm_name  = "master-3",
      node_name = "pvepfsense",
      ip_address = "192.168.1.207",
      cloud_image_id = module.pvelenovo_cloud_image.cloud_image_id
    }
  ]

  support_masters_map = { for idx, val in local.support_masters : idx => val }
}

module "control_nodes_module" {
  source = "./vm"
  vm_name = local.main_master_vm_name
  node_name = local.main_master_node_name
  memory = 4096
  disk_size = 50
  ip_address = local.main_master_ip_address
  cloud_image_id = module.pve_cloud_image.cloud_image_id
    commands = [
    "echo \"done\" > /tmp/cloud-config.done",
    "/k3s_install.sh"
  ]
  files = [
    {
      file_path = "/tmp/cloud.cloud"
      content: "From cloud config"
    },
    {
      file_path = "k3s_install.sh"
      content = templatefile("${path.module}/scripts/k3s-server.sh.tftpl", {
        mode = "server"
        tokens       = [var.k3s_token]
        alt_names    = ["192.168.1.200"]
        server_hosts = []
        node_taints  = ["CriticalAddonsOnly=true:NoExecute"]
        disable      = ["servicelb"]
        datastores = [var.db_connection_url]
      })
    }
  ]
  additional_packages = ["vim"]
}

module "support_control_nodes_module" {
  depends_on = [ module.control_nodes_module ]
  source = "./vm"
  providers = {
    proxmox = proxmox
  }
  for_each = local.support_masters_map
  vm_name = each.value.vm_name
  node_name = each.value.node_name
  memory = 4096
  disk_size = 50
  ip_address = each.value.ip_address
  cloud_image_id = each.value.cloud_image_id
  commands = [
    "echo \"done\" > /tmp/cloud-config.done",
    "/k3s_install.sh"
  ]
  files = [
    {
      file_path = "/tmp/cloud.cloud"
      content: "From cloud config"
    },
    {
      file_path = "k3s_install.sh"
      content = templatefile("${path.module}/scripts/k3s-server.sh.tftpl", {
        mode = "server"
        tokens       = [var.k3s_token]
        server_hosts = ["192.168.1.205"]
        node_taints  = ["CriticalAddonsOnly=true:NoExecute"]
        disable      = ["servicelb"]
        datastores = [var.db_connection_url]
        alt_names    = []
      })
    }
  ]
  additional_packages = ["vim"]
}

output "main_master_vm_ipv4_address" {
  value = module.control_nodes_module.vm_ipv4_address
}
output "support_control_vm_ipv4_address" {
  value = [for instance in module.support_control_nodes_module : instance.vm_ipv4_address]
}