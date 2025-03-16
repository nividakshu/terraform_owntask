terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}
#ssh security group

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh-${terraform.workspace}"
  description = "Allow ssh access"

}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# IAM role-aws_iam_role

resource "aws_iam_role" "s3_access" {
  name = "s3_access-${terraform.workspace}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

# IAM role-aws_iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "s3_policy" {
  role       = aws_iam_role.s3_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# IAM role-aws_iam_instance_profile

resource "aws_iam_instance_profile" "s3_profile" {
  name = "s3-profile-${terraform.workspace}"
  role = aws_iam_role.s3_access.name
}

#ec2 instance

resource "aws_instance" "ec2-instance" {
  ami                     = "ami-0c2e61fdcb5495691"
  instance_type           = var.instance_type 
  key_name = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  iam_instance_profile   = aws_iam_instance_profile.s3_profile.name
}

#s3 bucket

resource "aws_s3_bucket" "my_s3" {
  bucket = "${var.s3_bucket_name}-${terraform.workspace}"
}
