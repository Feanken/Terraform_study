output "ubuntu_image_id" {
  description = "Ubuntu 24.04 image ID"
  value       = data.huaweicloud_images_image.ubuntu.id
}

output "available_ecs_flavors" {
  description = "Available ECS flavors"
  value       = data.huaweicloud_compute_flavors.monitoring.flavors
}