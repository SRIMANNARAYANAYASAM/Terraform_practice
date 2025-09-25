resource "aws_instance" "dev" {
    ami = var.instance_ami
    instance_type = var.instance_type
  
}