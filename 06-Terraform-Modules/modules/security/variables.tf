variable "sg_name" {
  description = "Name of the Security Group"
  type        = string
}

variable "ssh_cidr" {
  description = "Allowed IPv4 CIDR for SSH access"
  type        = string
}