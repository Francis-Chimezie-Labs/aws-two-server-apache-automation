data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


resource "aws_vpc" "apache_vpc" {
  cidr_block           = "10.60.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "apache-two-server-vpc"
  }
}


resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.apache_vpc.id
  cidr_block              = "10.60.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "apache-public-subnet"
  }
}


resource "aws_internet_gateway" "apache_igw" {
  vpc_id = aws_vpc.apache_vpc.id

  tags = {
    Name = "apache-two-server-igw"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.apache_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.apache_igw.id
  }

  tags = {
    Name = "apache-public-route-table"
  }
}


resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_security_group" "apache_sg" {
  name        = "apache-two-server-sg"
  description = "Allow SSH from my IP and HTTP from the internet"
  vpc_id      = aws_vpc.apache_vpc.id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "apache-two-server-sg"
  }
}


resource "aws_key_pair" "apache_key" {
  key_name   = "apache-two-server-key"
  public_key = file(pathexpand(var.ssh_public_key_path))

  tags = {
    Name = "apache-two-server-key"
  }
}


resource "aws_instance" "apache_server_1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.apache_sg.id]
  key_name                    = aws_key_pair.apache_key.key_name
  associate_public_ip_address = true

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "Apache-Server-1"
  }
}


resource "aws_instance" "apache_server_2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.apache_sg.id]
  key_name                    = aws_key_pair.apache_key.key_name
  associate_public_ip_address = true

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "Apache-Server-2"
  }
}