
variable "environment" {
  type = string
}

variable "s3_buckets" {
  type = list(string)
}

variable "sg_name" {
  type = string
}

variable "s3_base_object" {}

variable "org-name" {}

variable "region" {}