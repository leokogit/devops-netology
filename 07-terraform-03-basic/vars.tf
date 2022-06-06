#token
variable "yc_token" {

   default = ""
}

# ID облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yc_cloud_id" {
  default = ""
}

# Folder облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yc_folder_id" {
  default = ""
}

# ID образа
# ID compute image list
variable "centos-7-base" {
  default = ""
}
