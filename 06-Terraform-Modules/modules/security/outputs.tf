output "security_group_id" {
  description = "ID of the Security Group created by this module"
  value       = huaweicloud_networking_secgroup.this.id
}