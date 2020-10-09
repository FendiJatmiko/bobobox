resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/26"
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.my_vpc.id}"
  cidr_block        = "10.0.0.0/28"
  availability_zone = "ap-southeast-1a"
}

resource "aws_internet_gateway" "iw" {
  vpc_id = "${aws_vpc.my_vpc.id}"
}

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.iw.id}"
  }
}

resource "aws_route_table_association" "public_route_assoc" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_instance" "ec2_server" {
  ami                         = "ami-0c8e97a27be37adfd"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.public.id}"
  associate_public_ip_address = "true"
  key_name                    = "nyobi-mark1"
  vpc_security_group_ids = [
  "${aws_security_group.allow_ssh.id}"]

  user_data = <<EOF
            #!/bin/bash
            sudo apt update -y 
            sudo apt install ca-certificates curl openssh-server postfix -y
            cd /tmp
            curl -LO https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh
            sudo bash /tmp/script.deb.sh
            sudo apt install gitlab-ce
            sudo ufw allow http
            sudo ufw allow OpenSSH
            sudo ufw allow https
        EOF

  tags = {
    Name = "Gitlab-Runner"
  }
}

resource "aws_security_group" "allow_ssh" {
  name   = "allow_ssh"
  vpc_id = "${aws_vpc.my_vpc.id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  tags = {
    Name = "Ec2-Gitlab-Runner"
  }
}

output "ec2_server_ip" {
  value = "${aws_instance.ec2_server.public_ip}"
}
