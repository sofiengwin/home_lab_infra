locals {
  node_name = "pve"
  vm_name = "nginx-support-node"
  ip_address = "192.168.1.200"
}

data "local_file" "nginx_conf" {
  filename = "${path.module}/nginx/nginx.conf"
}

data "local_file" "index_html" {
  filename = "${path.module}/nginx/index.html"
}

module "support_nodes_module" {
  source = "./vm"
  vm_name = local.vm_name
  node_name = local.node_name
  memory = 4096
  disk_size = 50
  ip_address = local.ip_address
  cloud_image_id = module.pve_cloud_image.cloud_image_id
    commands = [
    "systemctl start nginx",
    # "cp nginx.conf /etc/nginx/nginx.conf",
    "echo \"done\" > /tmp/cloud-config.done",
  ]
  files = [
    {
      file_path = "/tmp/cloud.cloud"
      content = "From cloud config"
    },
    {
      file_path = "/etc/nginx/nginx.conf"
      content = data.local_file.nginx_conf.content
    },
    {
      file_path = "/var/www/html/index.html"
      content = data.local_file.index_html.content
    }
  ]
  additional_packages = ["nginx"]
}

output "support_vm_ipv4_address" {
  value = module.support_nodes_module.vm_ipv4_address
}

output "cloud_image_id" {
  value = module.pve_cloud_image.cloud_image_id
}
