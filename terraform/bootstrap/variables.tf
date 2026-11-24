variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "profile" {
  type    = string
  default = "glpi"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique name for the Terraform state bucket"
}