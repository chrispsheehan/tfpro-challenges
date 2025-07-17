
variable "environement" {
  type = number
}

variable "s3_buckets" {
    type = list(string)
}

variable "s3_base_object" {}

variable "org-name" {}

variable "region" {}