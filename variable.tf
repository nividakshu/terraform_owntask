variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key name"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}
