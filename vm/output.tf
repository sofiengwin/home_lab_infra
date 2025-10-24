output "ipv4_addresses" {
  value = proxmox_virtual_environment_vm.ubuntu_vm.ipv4_addresses
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.ubuntu_vm.id
}
