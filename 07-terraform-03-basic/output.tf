output "internal_ip_address_vm_1" {
  value = {
    for node in yandex_compute_instance.vm-1:
        node.hostname => node.network_interface.0.ip_address
  }
}

output "external_ip_address_vm_1" {
  value = {
    for node in yandex_compute_instance.vm-1:
        node.hostname => node.network_interface.0.nat_ip_address
  }
}

output "internal_ip_address_vm_2" {
  value = {
    for node in yandex_compute_instance.vm-2:
        node.hostname => node.network_interface.0.ip_address
  }
}

output "external_ip_address_vm_2" {
  value = {
    for node in yandex_compute_instance.vm-2:
        node.hostname => node.network_interface.0.nat_ip_address
  }
}
