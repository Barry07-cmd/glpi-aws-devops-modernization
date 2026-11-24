variable "name" {
  type = string
}

variable "max_images" {
  type    = number
  default = 10
}

variable "force_delete" {
  type    = bool
  default = false
}
