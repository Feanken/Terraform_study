variable "ecs_password" {
  description = "Password for ECS administrator"
  type        = string
  sensitive   = true
}
variable "ssh_cidr" {
  description = "Trusted IPv4 CIDR allowed to access ECS via SSH"
  type        = string
}