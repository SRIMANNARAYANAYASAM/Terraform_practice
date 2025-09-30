# VPC
resource "aws_vpc" "CVPC" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "My_CVPC"
    }
}

# public_subnet
resource "aws_subnet" "pusb1" {
    vpc_id = aws_vpc.CVPC.id
    availability_zone = "1a"
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "public_subnet_1"
    }
}

# public_subnet
resource "aws_subnet" "pusb2" {
    vpc_id = aws_vpc.CVPC.id
    availability_zone = "1b"
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "public_subnet_2"
    }
}


# internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.CVPC.id
    tags = {
      Name = "ig"
    }
  
}
#public_route_table
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.CVPC.id
  tags = {
    Name = "PUB_RTBL"
  }
}
# Route to internet
resource "aws_route" "internet_access" {
    route_table_id = aws_route_table.name.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  
}

# route table association
resource "aws_route_table_association" "pub_sub_acc1" {
    subnet_id = aws_subnet.pusb1.id
    route_table_id = aws_route_table.name.id
}

# route table association
resource "aws_route_table_association" "pub_sub_acc2" {
    subnet_id = aws_subnet.pusb2.id
    route_table_id = aws_route_table.name.id
}


# SG's

resource "aws_security_group" "SG" {
    name = "web-sg"
    description = "only for ssh traffic"
    vpc_id = aws_vpc.CVPC.id

    ingress {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "TCP"
        cidr_blocks  = ["0.0.0.0/0"]
        }

    ingress {
        description = "Allow HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "TCP"
        cidr_blocks  = ["0.0.0.0/0"]
        }

    ingress  {
        description = "Allow HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "TCP"
        cidr_blocks  = ["0.0.0.0/0"]
        }

    egress {
        description = "Allow all outbound"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
}

# key_pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-ec2-key"
  public_key = file("~/.ssh/id_rsa.pub") # Path to your public key file
}
# EC2
resource "aws_instance" "ec2" {
    ami                     = "ami-08982f1c5bf93d976"
    instance_type           = "t2.micro"
    subnet_id               = aws_subnet.pusb1.id
    vpc_security_group_ids  = [aws_security_group.id]
    key_name                = aws_key_pair.my_key_pair
    tags = {
      Name = "web_server"
    }
  
}


resource "aws_secretsmanager_secret" "name" {
  
}