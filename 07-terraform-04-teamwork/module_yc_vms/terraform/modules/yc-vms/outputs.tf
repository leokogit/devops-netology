output "internal_ip_address_vm" {
 value = yandex_compute_instance.vm.*.network_interface.0.ip_address
 description = "internal_ip_address for vm"
}
output "external_ip_address_vm" {
   value = yandex_compute_instance.vm.*.network_interface.0.nat_ip_address
   description = "external_ip_address for vm"
}
output "fqdn" {
  description = "The fully qualified DNS name of this instance"
  value       = yandex_compute_instance.vm.*.fqdn
}
output "yandex_zone" {
  value       = yandex_compute_instance.vm.*.zone
  description = "region"
}