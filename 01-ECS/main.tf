
# ==========================================
# 1. TERRAFORM PROVIDER
# ==========================================

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


# ==========================================
# 2. VIRTUAL PRIVATE CLOUD
# ==========================================

resource "huaweicloud_vpc" "lab" {
  name = "terraform-study-vpc"
  cidr = "192.168.0.0/16"
}


# ==========================================
# 3. SUBNET
# ==========================================

resource "huaweicloud_vpc_subnet" "lab_subnet" {
  name       = "terraform-study-subnet"
  cidr       = "192.168.1.0/24"
  gateway_ip = "192.168.1.1"
  vpc_id     = huaweicloud_vpc.lab.id
}


# ==========================================
# 4. SECURITY GROUP
# ==========================================

resource "huaweicloud_networking_secgroup" "lab_sg" {
  name                 = "terraform-study-sg"
  description          = "Security group for Terraform lab"
  delete_default_rules = true
}


# SSH INGRESS
resource "huaweicloud_networking_secgroup_rule" "ssh_ingress" {
  security_group_id = huaweicloud_networking_secgroup.lab_sg.id

  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 22
  port_range_max   = 22
  remote_ip_prefix = "182.253.12.188/32"
}


# OUTBOUND TRAFFIC
resource "huaweicloud_networking_secgroup_rule" "allow_egress" {
  security_group_id = huaweicloud_networking_secgroup.lab_sg.id

  direction        = "egress"
  ethertype        = "IPv4"
  remote_ip_prefix = "0.0.0.0/0"
}


# ==========================================
# 5. AVAILABILITY ZONES
# ==========================================

data "huaweicloud_availability_zones" "available" {}

output "available_az" {
  value = data.huaweicloud_availability_zones.available.names
}


# ==========================================
# 6. ECS FLAVOR LOOKUP
# ==========================================

data "huaweicloud_compute_flavors" "small" {
  availability_zone = data.huaweicloud_availability_zones.available.names[0]
  cpu_core_count    = 1
  memory_size       = 1
}

output "available_flavors" {
  value = data.huaweicloud_compute_flavors.small.flavors
}


# ==========================================
# 7. UBUNTU 24.04 IMAGE LOOKUP
# ==========================================

data "huaweicloud_images_images" "ubuntu" {
  os         = "Ubuntu"
  name_regex = "24\\.04"
  visibility = "public"
}

output "ubuntu_images" {
  value = data.huaweicloud_images_images.ubuntu.images
}


# ==========================================
# 8. ECS INSTANCE
# ==========================================

resource "huaweicloud_compute_instance" "lab_ecs" {
  name              = "terraform-study-ecs"
  charging_mode     = "postPaid"
  availability_zone = data.huaweicloud_availability_zones.available.names[0]

  flavor_id = "t6.small.1"
  image_id  = "33beba0a-9caa-4241-a427-97799a440e4e"

  # ECS PASSWORD
  admin_pass = var.ecs_password

  # START / STOP / REBOOT
  power_action = var.ecs_power_action

  # SECURITY GROUP
  security_group_ids = [
    huaweicloud_networking_secgroup.lab_sg.id
  ]

  # NETWORK
  network {
    uuid = huaweicloud_vpc_subnet.lab_subnet.id
  }

  # SYSTEM DISK
  system_disk_type = "SSD"
  system_disk_size = 40
}


# ==========================================
# 9. ECS OUTPUTS
# ==========================================

output "ecs_id" {
  value = huaweicloud_compute_instance.lab_ecs.id
}

output "ecs_status" {
  value = huaweicloud_compute_instance.lab_ecs.status
}

output "ecs_private_ip" {
  value = huaweicloud_compute_instance.lab_ecs.network[0].fixed_ip_v4
}
