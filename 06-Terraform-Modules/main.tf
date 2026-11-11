module "network" {
  source = "./modules/network"

  vpc_name       = "terraform-module-vpc"
  vpc_cidr       = "192.168.0.0/16"
  subnet_name    = "terraform-module-subnet"
  subnet_cidr    = "192.168.1.0/24"
  subnet_gateway = "192.168.1.1"
}
module "security" {
  source   = "./modules/security"
  sg_name  = "terraform-module-sg"
  ssh_cidr = var.ssh_cidr
}

module "compute" {
  source = "./modules/compute"

  ecs_name          = "terraform-module-ecs"
  ecs_flavor        = data.huaweicloud_compute_flavors.available.ids[0]
  image_id          = data.huaweicloud_images_image.ubuntu.id
  availability_zone = data.huaweicloud_availability_zones.available.names[0]

  subnet_id         = module.network.subnet_ipv4_id
  security_group_id = module.security.security_group_id

  ecs_password = var.ecs_password
}
