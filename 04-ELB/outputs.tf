output "available_ecs_flavors" {
  description = "Available small ECS flavors"
  value       = data.huaweicloud_compute_flavors.small.flavors[*].id
}

output "ubuntu_image_id" {
  description = "Ubuntu 24.04 image ID"
  value       = data.huaweicloud_images_image.ubuntu.id
}

output "selected_elb_flavor" {
  description = "Selected L7 Elastic flavor for Dedicated ELB"

  value = {
    id   = data.huaweicloud_elb_flavors.l7_small.flavors[0].id
    name = data.huaweicloud_elb_flavors.l7_small.flavors[0].name
    type = data.huaweicloud_elb_flavors.l7_small.flavors[0].type
  }
}