resource "aws_instance" "example" {
  ami           = "ami-0d0f28110d16ee7d6"
  instance_type = var.instance_type
}


