resource "yandex_compute_instance" "worker_node" {
  count = 4
  name                = "worker-node-${count.index+1}"
  hostname            = "worker-node-${count.index+1}"
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