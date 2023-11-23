resource "local_file" "hosts" {
  content = <<-DOC
  [hosts]
  master.master-node ansible_host=${yandex_compute_instance.master_node.network_interface.0.nat_ip_address}

  [workers]
    ${join("\n", [
      for idx, worker in yandex_compute_instance.worker_node : 
      "${worker.name} ansible_host=${worker.network_interface.0.nat_ip_address}"
    ])}
  DOC
filename = "../inventory/hosts.txt"

  depends_on = [
    yandex_compute_instance.master_node
  ]
}
