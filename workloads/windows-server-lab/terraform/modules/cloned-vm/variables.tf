variable "vm_name" {
  description = "The name of VM"
  type        = string
}

variable "description" {
  description = "The description of VM"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A list of tags to apply to the VM"
  type        = list(string)
  default     = []
}
