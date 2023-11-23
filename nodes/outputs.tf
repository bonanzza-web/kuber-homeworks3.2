output "ip_address" {
  value = yandex_compute_instance.master_node.network_interface.0.nat_ip_address
}

output "workers_ip_addresses" {
  value = [for instance in yandex_compute_instance.worker_node : instance.network_interface[0].nat_ip_address]
}