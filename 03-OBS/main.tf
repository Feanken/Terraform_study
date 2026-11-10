terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.100"
    }
  }
}

provider "huaweicloud" {
  region = "ap-southeast-4"
}

resource "huaweicloud_obs_bucket" "lab" {
  bucket        = var.bucket_name
  acl           = "private"
  storage_class = "STANDARD"
}