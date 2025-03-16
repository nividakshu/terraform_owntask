provider "aws" {
  region = var.aws_region
}

module "ec2-s3" {
  source          = "./modules"
  aws_region      = var.aws_region
  instance_type   = var.instance_type
  ssh_key_name    = var.ssh_key_name
  s3_bucket_name  = var.s3_bucket_name
}

output "ec2_public_ip" {
  value = module.ec2-s3.ec2_public_ip
}

output "s3_bucket_name" {
  value = module.ec2-s3.s3_bucket_name
}
