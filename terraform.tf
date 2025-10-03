terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.84.0"
    }
  }
}


provider "proxmox" {
  endpoint = "https://192.168.1.232:8006/"
  insecure = true
  # Username and password set via environment variables for better security
}