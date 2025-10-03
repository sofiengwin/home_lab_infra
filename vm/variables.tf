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
  type        = number
  default     = 20
}

variable "image_url" {
  description = "URL of the cloud image to download"
  type        = string
  default     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
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