variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "vpc" {
  type        = string
  default     = "bonanzza-net"
  description = "VPC name"
}

variable "cidr" {
  type        = list(string)
  default     = [ "10.2.3.0/24" ]
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
}

variable "os_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS Family"
}