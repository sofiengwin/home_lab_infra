resource "proxmox_virtual_environment_vm" "ubuntu_clone" {
  name      = "ubuntu-clone-update"
  node_name = "pve"

  clone {
    vm_id = var.vm_id
    full  = true
  }

  agent {
    enabled = true
  }

  memory {
    dedicated = 4096
  }

  initialization {
    dns {
      servers = ["1.1.1.1", "192.168.1.1"]
    }
    ip_config {
      ipv4 {
        address = "192.168.1.32/24"
        gateway = "192.168.1.1"
      }
    }
  }

  # provisioner "remote-exec" {
  #      inline = [
  #     templatefile("${path.module}/../scripts/k3s-server.sh.tftpl", {
  #       mode         = "server"
  #       server_hosts = []
  #       node_taints  = ["CriticalAddonsOnly=true:NoExecute"]
  #       disable      = []
  #     })
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = "sofien"
  #     host        = self.ipv4_addresses[1][0]
  #     private_key = file("/Users/godwinogbara/.ssh/homelab")
  #     timeout     = "1m"
  #   }
  # }
}

variable "vm_id" {
  type = number
}

output "vm_ipv4_address" {
  value = proxmox_virtual_environment_vm.ubuntu_clone.ipv4_addresses[1][0]
}