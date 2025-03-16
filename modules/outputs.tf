output "ec2_public_ip" {
  value = aws_instance.ec2-instance.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.my_s3.id
}
