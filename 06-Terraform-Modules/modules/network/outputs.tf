output "vpc_id" {
  description = "ID of the created VPC"
  value       = huaweicloud_vpc.this.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = huaweicloud_vpc_subnet.this.id
}

output "subnet_ipv4_id" {
  description = "IPv4 subnet ID for ECS networking"
  value       = huaweicloud_vpc_subnet.this.ipv4_subnet_id
}