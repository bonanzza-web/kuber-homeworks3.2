resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 100"
  }

  depends_on = [
    local_file.hosts
  ]
}

resource "null_resource" "kubeadm" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../inventory/hosts.txt ../playbook.yml"
}

  depends_on = [
    null_resource.wait
  ]
}

resource "null_resource" "master-node-setup" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../inventory/hosts.txt ../master-forward.yml"
  }

  depends_on = [ 
    null_resource.kubeadm
   ]
}