output "ecs_id" {
  description = "ID of the created ECS instance"
  value       = huaweicloud_compute_instance.this.id
}

output "ecs_private_ip" {
  description = "Private IP address of the ECS"
  value       = huaweicloud_compute_instance.this.access_ip_v4
}

output "ecs_public_ip" {
  description = "Public IP address allocated to the ECS"
  value       = huaweicloud_vpc_eip.this.address
}

output "eip_id" {
  description = "ID of the allocated Elastic IP"
  value       = huaweicloud_vpc_eip.this.id
}