module "yc-vms" {
  source          = "./modules/yc-vms"
  image_family    = "ubuntu"
  yc_folder_id    = var.yc_folder_id
  count           = var.instance_count
  name            = "vm-${count.index + 1}"
  hostname        = "dev-${count.index + 1}.netology.cloud"
  subnet          = "sn-dev-1"
  is_nat          = true

  cores  = 2
  memory = 2
  size   = "30"
}

variable "instance_count" {
  default = "2"
}
