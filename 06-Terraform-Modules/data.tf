data "huaweicloud_availability_zones" "available" {}

data "huaweicloud_compute_flavors" "available" {
  availability_zone = data.huaweicloud_availability_zones.available.names[0]
  cpu_core_count    = 1
  memory_size       = 1
}

data "huaweicloud_images_image" "ubuntu" {
  name        = "Ubuntu 24.04 server 64bit"
  most_recent = true
}