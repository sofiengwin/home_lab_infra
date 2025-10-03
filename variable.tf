# variable "masters" {
#   type = object({
#     cores     = optional(number),
#     memory    = optional(number),
#     disk_size = optional(string),
#     user      = optional(string),
#     password  = optional(string),
#   })
# }

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

