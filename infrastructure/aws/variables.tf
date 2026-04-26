variable "backend_bucket" {
  type = string
  description = "backend s3 bucket name"
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "dynamodb_table" {
  type = string
}

variable "assume_role_arn" {
  type = string
  sensitive = true
}

variable "assume_role_session" {
  type = string
  sensitive = true
}

variable "project_name" {
  type = string
  default = "multi-fin-data-platform"
}