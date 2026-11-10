terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
    }
  }
}

provider "huaweicloud" {
  region = "ap-southeast-4"
}

module "networking" {
  source = "./modules/networking"

  vpc_name = "modules-study-vpc"
  vpc_cidr = "10.20.0.0/16"
}

output "networking_vpc_id" {
  value = module.networking.vpc_id
}