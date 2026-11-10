variable "ecs_password" {
  description = "Password for Ubuntu ECS"
  type        = string
  sensitive   = true
}

variable "ecs_power_action" {
  description = "Power action for ECS"
  type        = string
  default     = "ON"

  validation {
    condition     = contains(["ON", "OFF", "REBOOT"], var.ecs_power_action)
    error_message = "Use ON, OFF, or REBOOT."
  }
}