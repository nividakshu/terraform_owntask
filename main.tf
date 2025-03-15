module "my_ec2" {
    source = "./module/ec2"
    instance_type = "t2.micro"
}