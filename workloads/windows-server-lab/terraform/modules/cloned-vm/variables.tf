variable "vm_name" {
  description = "The name of VM"
  type        = string
}

variable "vm_id" {
  description = "The ID of VM"
  type        = number
  default     = null
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

variable "clone_from" {
  description = "The name of the VM to clone from"
  type        = string
}
