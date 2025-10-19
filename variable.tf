variable "master_nodes" {
  type = list(object({
    vm_name  = string,
    node_name = string,
    vm_description = string
    cores     = number,
    memory    = number,
    disk_size = string
  }))
}
variable "worker_nodes" {
  type = list(object({
    vm_name  = string,
    node_name = string,
    vm_description = string
    cores     = number,
    memory    = number,
    disk_size = string
  }))
}

variable "macaddress_map" {
  description = "Map of VM names to MAC addresses"
  type        = map(string)
  default     = {}
  
}
# variable "workers" {
#   description = "Worker VMs"
#   type = map(object({
#     cores     = optional(number),
#     memory    = optional(number),
#     disk_size = optional(string),
#     user      = optional(string),
#     password  = optional(string),
#   }))
# }

# variable "nodes" {
#   description = "List of all available nodes"
#   type        = list(string)
# }


# variable "api_hostnames" {
#   description = "Alternative hostnames for the API server."
#   type        = list(string)
#   default     = []
# }

# variable "k3s_disable_components" {
#   description = "List of components to disable. Ref: https://rancher.com/docs/k3s/latest/en/installation/install-options/server-config/#kubernetes-components"
#   type        = list(string)
#   default     = []
# }


# macaddress = [
#   "4a:1e:c7:c5:cf:89",
#   "46:8d:51:5d:04:ed",
#   "ea:ce:b2:7a:72:7c",
#   "02:8f:94:a9:c6:61",
#   "06:c9:06:bd:0f:e3",
#   "b6:e7:2d:6c:bc:d6",
#   "d2:a8:33:26:fa:1d",
#   "9e:4e:b1:b3:70:b5",
#   "1e:f5:65:3f:e9:0e",
#   "7a:bf:e5:c0:9b:72",
# ]
