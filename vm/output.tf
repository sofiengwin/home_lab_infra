output "vm_id" {
  description = "ID of the created VM"
  value       = proxmox_virtual_environment_vm.ubuntu_vm.id
}

output "vm_name" {
  description = "Name of the created VM"
  value       = var.vm_name
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