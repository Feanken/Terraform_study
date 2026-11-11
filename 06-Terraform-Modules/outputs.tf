output "vpc_id" {
  description = "VPC ID from Network Module"
  value       = module.network.vpc_id
}

output "subnet_id" {
  description = "Subnet ID from Network Module"
  value       = module.network.subnet_id
}

output "security_group_id" {
  description = "Security Group ID from Security Module"
  value       = module.security.security_group_id
}

output "ecs_id" {
  description = "ECS ID from Compute Module"
  value       = module.compute.ecs_id
}

output "ecs_private_ip" {
  description = "Private IP address of ECS"
  value       = module.compute.ecs_private_ip
}

output "ecs_public_ip" {
  description = "Public IP address of ECS"
  value       = module.compute.ecs_public_ip
}