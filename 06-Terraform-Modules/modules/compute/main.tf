resource "huaweicloud_compute_instance" "this" {
  name              = var.ecs_name
  image_id          = var.image_id
  flavor_id         = var.ecs_flavor
  availability_zone = var.availability_zone
  charging_mode     = "postPaid"

  admin_pass = var.ecs_password

  security_group_ids = [
    var.security_group_id
  ]

  network {
    uuid = var.subnet_id
  }

  system_disk_type = "GPSSD"
  system_disk_size = 40
}

resource "huaweicloud_vpc_eip" "this" {
  publicip {
    type = "5_bgp"
  }

  bandwidth {
    name        = "terraform-module-bandwidth"
    size        = 1
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "huaweicloud_compute_eip_associate" "this" {
  public_ip   = huaweicloud_vpc_eip.this.address
  instance_id = huaweicloud_compute_instance.this.id
}