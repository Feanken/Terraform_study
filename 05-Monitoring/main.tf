resource "huaweicloud_vpc" "monitoring" {
  name = "terraform-monitoring-vpc"
  cidr = "192.168.0.0/16"
}

resource "huaweicloud_vpc_subnet" "monitoring" {
  name       = "terraform-monitoring-subnet"
  cidr       = "192.168.1.0/24"
  gateway_ip = "192.168.1.1"

  vpc_id = huaweicloud_vpc.monitoring.id
}

resource "huaweicloud_networking_secgroup" "monitoring" {
  name                 = "terraform-monitoring-sg"
  description          = "Security group for monitoring lab"
  delete_default_rules = true
}

resource "huaweicloud_networking_secgroup_rule" "egress" {
  security_group_id = huaweicloud_networking_secgroup.monitoring.id

  direction        = "egress"
  ethertype        = "IPv4"
  remote_ip_prefix = "0.0.0.0/0"
}

resource "huaweicloud_compute_keypair" "monitoring" {
  name       = "terraform-monitoring-key"
  public_key = trimspace(file(pathexpand("~/.ssh/terraform-monitoring.pub")))
}

data "huaweicloud_images_image" "ubuntu" {
  name        = "Ubuntu 24.04 server 64bit"
  most_recent = true
  visibility  = "public"
  os          = "Ubuntu"
}

data "huaweicloud_compute_flavors" "monitoring" {
  availability_zone = "ap-southeast-4a"
  performance_type  = "normal"
  cpu_core_count    = 1
  memory_size       = 1
}

resource "huaweicloud_compute_instance" "monitoring" {
  name              = "terraform-monitoring-ecs"
  image_id          = data.huaweicloud_images_image.ubuntu.id
  flavor_id         = "s7n.small.1"
  availability_zone = "ap-southeast-4a"
  security_group_ids = [
    huaweicloud_networking_secgroup.monitoring.id
  ]
  key_pair = huaweicloud_compute_keypair.monitoring.name

  system_disk_type = "SAS"
  system_disk_size = 40

  network {
    uuid = huaweicloud_vpc_subnet.monitoring.id
  }
}

resource "huaweicloud_vpc_eip" "monitoring" {
  publicip {
    type = "5_bgp"
  }

  bandwidth {
    name        = "terraform-monitoring-bandwidth"
    size        = 1
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "huaweicloud_compute_eip_associate" "monitoring" {
  public_ip   = huaweicloud_vpc_eip.monitoring.address
  instance_id = huaweicloud_compute_instance.monitoring.id
}

resource "huaweicloud_networking_secgroup_rule" "ssh" {
  security_group_id = huaweicloud_networking_secgroup.monitoring.id

  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  ports            = "22"
  remote_ip_prefix = "182.253.12.188/32"
}

resource "huaweicloud_ces_alarmrule" "cpu" {
  alarm_name = "terraform-monitoring-cpu-alarm"
  alarm_type = "MULTI_INSTANCE"

  metric {
    namespace   = "SYS.ECS"
    metric_name = "cpu_util"

    dimensions {
      name  = "instance_id"
      value = huaweicloud_compute_instance.monitoring.id
    }
  }

  condition {
    period              = 300
    filter              = "average"
    comparison_operator = ">"
    value               = 70
    unit                = "%"
    count               = 1
  }

  alarm_action_enabled = false
  alarm_level          = 2
  alarm_enabled        = true
}