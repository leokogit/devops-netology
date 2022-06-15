# Terraform configuration
terraform {
 required_providers {
   yandex = {
     source  = "yandex-cloud/yandex"
   }
 }
 required_version = ">= 0.60.0"
}

provider "yandex" {
#  token     = var.yc_token
  service_account_key_file = "key.json"
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-a"
}
