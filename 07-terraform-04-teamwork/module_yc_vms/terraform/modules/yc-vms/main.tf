data "yandex_vpc_subnet" "sn-dev-1" {
  folder_id = var.yc_folder_id
  name = "sn-dev-1"
}

resource "yandex_compute_instance" "vm" {
  name        = var.name
  hostname    = var.hostname
  count       = var.instance_count
  platform_id = var.platform_id
  zone        = var.zones[0]
  folder_id   = var.yc_folder_id

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = var.ubuntu
      type        = "network-nvme"
      size        = "30"
    }
  }

  network_interface {
    subnet_id          = data.yandex_vpc_subnet.sn-dev-1.id
    nat                = var.is_nat
    nat_ip_address     = var.nat_ip_address
    ip_address         = var.ip_address
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
  allow_stopping_for_update = true

}
