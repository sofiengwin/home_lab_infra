output "ipv4_addresses" {
  value = proxmox_virtual_environment_vm.ubuntu_vm.ipv4_addresses
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.ubuntu_vm.id
}

# output "primary_ipv4" {
#   value = try(
#     split("/", [
#       for a in flatten(proxmox_virtual_environment_vm.ubuntu_vm.ipv4_addresses) : a
#       if !startswith(a, "127.")
#     ][0])[0],
#     null
#   )
# }