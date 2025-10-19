locals {
  node_name = "pve"
  vm_name = "nginx-support-node"
  ip_address = "192.168.1.200"

  nginx_conf = <<-EOT
    events {}

    stream {
      upstream k3s_servers {
        server 191.168.1.205:6443;
        server 191.168.1.206:6443;
        server 191.168.1.207:6443;
      }

      server {
        listen 6443;
        proxy_pass k3s_servers;
      }
    }
  EOT

  index_html = <<-EOT
    <html>
      <head><title>Welcome to NGINX!</title></head>
      <body>
        <h1>NGINX installed via cloud-init 🚀</h1>
        <p>Instance: $(hostname)</p>
      </body>
    </html>
  EOT
}

data "local_file" "nginx_conf" {
  filename = "${path.module}/nginx/nginx.conf"
}

data "local_file" "index_html" {
  filename = "${path.module}/nginx/index.html"
}

module "support_node_user_data" {
  source = "./user_data"
  vm_name = local.vm_name
  node_name = local.node_name
  commands = [
    "systemctl start nginx",
    # "cp nginx.conf /etc/nginx/nginx.conf",
    "echo \"done\" > /tmp/cloud-config.done",
    "echo ${local.nginx_conf} > /tmp/cloud-config.conf"
  ]
  files = [
    {
      file_path = "/tmp/cloud.cloud"
      content: "From cloud config"
    },
    {
      file_path = "/tmp/nginx.conf"
      content: "local.nginx_conf"
    },
    {
      file_path = "/var/www/html/index.html"
      content: "local.index_html"
    },
  ]
  additional_packages = ["nginx"]
}

module "support_nodes_module" {
  source = "./vm"
  vm_name = local.vm_name
  node_name = local.node_name
  memory = 4096
  disk_size = 50
  ip_address = local.ip_address
  cloud_config_id = module.support_node_user_data.cloud_config_id
  cloud_image_id = module.cloud_image.cloud_image_id
}

output "support_vm_ipv4_address" {
  value = module.support_nodes_module.vm_ipv4_address
}

output "cloud_image_id" {
  value = module.cloud_image.cloud_image_id
}

output "conf" {
  value = data.local_file.nginx_conf.content
}

    # "systemctl enable nginx",
    # 
    # "systemctl status nginx",
    # sudo ss -tulpn
        # "cp nginx.conf /etc/nginx/nginx.conf",
