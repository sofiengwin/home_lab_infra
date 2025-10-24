locals {
  cloud_image_id_map = {
    "pve" = module.pve_cloud_image.cloud_image_id
    "pvepfsense" = module.pvepfsense_cloud_image.cloud_image_id
    "pvelenovo" = module.pvelenovo_cloud_image.cloud_image_id
  }
}


module "worker_nodes" {
  source = "./vm"
  providers = {
    proxmox = proxmox
  }
  for_each = var.worker_nodes
  vm_name = each.value.vm_name
  node_name = each.value.node_name
  memory = each.value.memory
  disk_size = each.value.disk_size
  ip_address = each.value.ip_address
  cloud_image_id = local.cloud_image_id_map[each.value.node_name]
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
        mode = "agent"
        tokens       = [var.k3s_token]
        server_hosts = ["https://192.168.1.200:6443"]
        node_taints  = []
        disable      = []
        datastores = []
        alt_names    = []
      })
    }
  ]
  additional_packages = ["vim"]
}

output "worker_nodes_vm_ipv4_address" {
  value = [for instance in module.worker_nodes : instance.vm_ipv4_address]
}