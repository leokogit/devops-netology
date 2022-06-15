resource "yandex_vpc_network" "network-1" {
  folder_id   = var.yc_folder_id
  name = "network1"
  description = "network1"
}

resource "yandex_vpc_subnet" "sn-dev-1" {
  folder_id      = var.yc_folder_id
  name           = "sn-dev-1"
  description    = "subnet sn-dev-1 "
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]

  depends_on = [
    yandex_vpc_network.network-1
  ]
}
