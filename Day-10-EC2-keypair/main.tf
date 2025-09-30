resource "aws_instance" "ec2_instance" {
  ami = var.ami
  instance_type = var.instance_type

}

resource "aws_key_pair" "ec2_key_pair" {
    key_name = "my_ec2_keypair"
    public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}

resource "aws_key" "name" {
  
}


