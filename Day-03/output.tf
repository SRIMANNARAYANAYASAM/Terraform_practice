output "ip" {
    value = aws_instance.dev.public_ip
  
}
output "az" {
    value = aws_instance.dev.availability_zone
  
}