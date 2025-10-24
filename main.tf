module "pve_cloud_image" {
  source = "./cloud_image"
  node_name = "pve"
}

module "pvepfsense_cloud_image" {
  source = "./cloud_image"
  node_name = "pvepfsense"
}

module "pvelenovo_cloud_image" {
  source = "./cloud_image"
  node_name = "pvelenovo"
}