resource "yandex_vpc_network" "bonanzza-net" {
  name                = var.vpc
}

resource "yandex_vpc_subnet" "bonanzza-subnet" {
  name                = var.vpc
  zone                = var.zone
  network_id          = yandex_vpc_network.bonanzza-net.id
  v4_cidr_blocks      = var.cidr
}

data "yandex_compute_image" "ubuntu" {
  family              = var.os_family
}

resource "yandex_compute_instance" "master_node" {
  name                = "master-node"
  hostname            = "master-node"
  resources {
    core_fraction     = 5
    cores             = 2
    memory            = 2
  }
  boot_disk {
    initialize_params {
      size            = 40
      image_id        = data.yandex_compute_image.ubuntu.id
    }
  }
  network_interface {
    subnet_id         = yandex_vpc_subnet.bonanzza-subnet.id
    nat               = true
  }
  metadata = {
    serial-port-enable = true
    ssh-keys = "ubuntu:${local.ssh_key}"
  }
}