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

resource "huaweicloud_vpc" "lab" {
  name = "terraform-elb-study-vpc"
  cidr = "192.168.0.0/16"
}

resource "huaweicloud_vpc_subnet" "lab" {
  name       = "terraform-elb-study-subnet"
  cidr       = "192.168.1.0/24"
  gateway_ip = "192.168.1.1"
  vpc_id     = huaweicloud_vpc.lab.id
}

resource "huaweicloud_networking_secgroup" "web" {
  name                 = "terraform-elb-study-sg"
  description          = "Security group for Terraform ELB lab"
  delete_default_rules = true
}

resource "huaweicloud_networking_secgroup_rule" "http" {
  security_group_id = huaweicloud_networking_secgroup.web.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "192.168.0.0/16"
}

resource "huaweicloud_networking_secgroup_rule" "egress" {
  security_group_id = huaweicloud_networking_secgroup.web.id
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
}

data "huaweicloud_compute_flavors" "small" {
  availability_zone = "ap-southeast-4a"
  cpu_core_count    = 1
  memory_size       = 1
}

data "huaweicloud_images_image" "ubuntu" {
  name        = "Ubuntu 24.04 server 64bit"
  most_recent = true
  visibility  = "public"
}

resource "huaweicloud_compute_instance" "web" {
  count = 2

  name               = "terraform-elb-web-${count.index + 1}"
  image_id           = data.huaweicloud_images_image.ubuntu.id
  flavor_id          = "t6.small.1"
  availability_zone  = "ap-southeast-4a"
  security_group_ids = [huaweicloud_networking_secgroup.web.id]

  system_disk_type = "SAS"
  system_disk_size = 40

  network {
    uuid = huaweicloud_vpc_subnet.lab.id
  }

  charging_mode = "postPaid"
  user_data     = file("${path.module}/cloud-init.yaml")
  depends_on = [
    huaweicloud_nat_snat_rule.lab
  ]
}

resource "huaweicloud_elb_loadbalancer" "web" {
  name              = var.elb_name
  cross_vpc_backend = false

  vpc_id         = huaweicloud_vpc.lab.id
  ipv4_subnet_id = huaweicloud_vpc_subnet.lab.ipv4_subnet_id
  ipv4_eip_id    = huaweicloud_vpc_eip.elb.id

  availability_zone = [
    "ap-southeast-4a"
  ]

  lifecycle {
    ignore_changes = [
      l4_flavor_id,
      l7_flavor_id
    ]
  }
}

data "huaweicloud_elb_flavors" "l7_small" {
  list_all = "true"
}

resource "huaweicloud_elb_listener" "http" {
  name            = "terraform-elb-http"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = huaweicloud_elb_loadbalancer.web.id
}

resource "huaweicloud_elb_pool" "web" {
  name        = "terraform-elb-web-pool"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = huaweicloud_elb_listener.http.id
}

resource "huaweicloud_elb_member" "web" {
  count = 2

  pool_id       = huaweicloud_elb_pool.web.id
  address       = huaweicloud_compute_instance.web[count.index].network[0].fixed_ip_v4
  protocol_port = 80
  subnet_id     = huaweicloud_vpc_subnet.lab.ipv4_subnet_id
}

resource "huaweicloud_elb_monitor" "web" {
  pool_id     = huaweicloud_elb_pool.web.id
  protocol    = "HTTP"
  interval    = 5
  timeout     = 3
  max_retries = 3
  url_path    = "/"
}

resource "huaweicloud_vpc_eip" "elb" {
  name = "terraform-elb-study-eip"

  publicip {
    type = "5_bgp"
  }

  bandwidth {
    name        = "terraform-elb-study-bandwidth"
    size        = 1
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "huaweicloud_nat_gateway" "lab" {
  name      = "terraform-elb-study-nat"
  spec      = "1"
  vpc_id    = huaweicloud_vpc.lab.id
  subnet_id = huaweicloud_vpc_subnet.lab.id
}

resource "huaweicloud_vpc_eip" "nat" {
  name = "terraform-elb-study-nat-eip"

  publicip {
    type = "5_bgp"
  }

  bandwidth {
    name        = "terraform-elb-study-nat-bandwidth"
    size        = 1
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "huaweicloud_nat_snat_rule" "lab" {
  nat_gateway_id = huaweicloud_nat_gateway.lab.id
  floating_ip_id = huaweicloud_vpc_eip.nat.id
  subnet_id      = huaweicloud_vpc_subnet.lab.id
  source_type    = 0
}