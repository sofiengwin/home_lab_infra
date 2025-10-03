module "workers" {
  source    = "./vm"
  vm_name   = "workers"
  memory    = "20186"
  disk_size = "20"
}

