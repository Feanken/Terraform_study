variable "ecs_name" {
  description = "Name of the ECS instance"
  type        = string
}

variable "ecs_flavor" {
  description = "ECS instance flavor"
  type        = string
}

variable "image_id" {
  description = "Ubuntu image ID"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for ECS"
  type        = string
}

variable "subnet_id" {
  description = "IPv4 subnet ID for ECS networking"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for ECS"
  type        = string
}

variable "ecs_password" {
  description = "Administrator password for ECS"
  type        = string
  sensitive   = true
}