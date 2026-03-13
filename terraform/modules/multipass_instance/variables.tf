variable "vm_name" {
  description = "Multipass instance name"
  type        = string
}

variable "cpu" {
  description = "Number of CPUs"
  type        = number
  default     = 1
}

variable "ram" {
  description = "Memory size (e.g. 2G)"
  type        = string
  default     = "2G"
}

variable "disk" {
  description = "Disk size (e.g. 10G)"
  type        = string
  default     = "10G"
}

variable "ssh_public_key" {
  description = "SSH public key to inject into the VM"
  type        = string
}

variable "cloud_init_template" {
  description = "Path to cloud-init template"
  type        = string
  default     = ""
}
