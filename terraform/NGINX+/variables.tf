
variable "project_id" {}
variable "region" {}
variable "zone" {}
variable "plus_machine_type" {}
variable "nginx_plus_os_image" {}
variable "nginx_controller_os_image" {}
variable "nginx_machine_type" {}
variable "ssh_username" {}
variable "ssh_pub_key_path" {}
variable "ssh_pri_key_path" {}

variable "prefix" {
  description = "A prefix used for all resources in this example"
  type        = string
  default     = "mholland"
}

