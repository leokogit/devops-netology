output "internal_ip_address_vm1" {
 value = yandex_compute_instance.vm1.network_interface.0.ip_address
 description = "internal_ip_address for vm1"
}
output "external_ip_address_vm1" {
   value = yandex_compute_instance.vm1.network_interface.0.nat_ip_address
   description = "external_ip_address for vm1"
}
output "yandex_vpc_subnet" {
  value       = yandex_vpc_network.network-1.id
  description = "Идентификатор подсети в которой создан инстанс"
}
output "fqdn" {
  description = "The fully qualified DNS name of this instance"
  value       = yandex_compute_instance.vm1.*.fqdn
}
output "yandex_zone" {
  value       = yandex_compute_instance.vm1.zone
  description = "region"
}
