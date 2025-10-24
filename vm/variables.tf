variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "node_name" {
  description = "Proxmox node name where VM will be created"
  type        = string
  default     = "pve"
}


variable "memory" {
  description = "Dedicated memory in MB"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = string
  default     = 20
}


variable "vm_description" {
  description = "Description for the VM"
  type        = string
  default     = "Kubernetes node VM"
}

variable "tags" {
  description = "Tags to apply to the VM"
  type        = list(string)
  default     = []
}

variable "cores" {
  type        = number
  description = "The number of cores to allocate to the VM"
  default     = 1
}

variable "sockets" {
  type        = number
  description = "The number of sockets to allocate to the VM"
  default     = 1
}
variable "ip_address" {
  type = string
}

variable "cloud_image_id" {
  type = string
}

variable "additional_packages" {
  type = list(string)
  default = []
}

variable "files" {
  type = list(object({
    file_path = string
    content = string
  }))

  default = []
}

variable "commands" {
  type = list(string)
  default = []
}