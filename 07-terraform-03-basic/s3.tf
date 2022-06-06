terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-bucket-s3"
    region     = "ru-central1-a"
    key        = "states/terraform.tfstate"
    access_key = ""
    secret_key = ""

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
