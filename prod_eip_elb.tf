provider "aws" {
  profile = "default"
  region = "us-west-2"
  }

resource "aws_s3_bucket" "prod-tf-course" {
  bucket = "tfs3-tasha-20201103"
  acl = "private"
}

resource "aws_default_vpc" "default"{
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-west-2a"
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-west-2b"
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_security_group" "prod_web" {
  name = "prod_web"
  description = "Allow standard http and https ports inbound and everything outbound"   

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 433
    to_port = 433
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" : "true"
  }
}
resource "aws_instance" "prod_web" {
  count = 2
  ami = "ami-019c091d13a1fa156"
  instance_type = "t2.nano"
  vpc_security_group_ids = [
    aws_security_group.prod_web.id
    ]

    tags = {
    "Terraform" : "true"
  }
}

resource "aws_eip_association" "prod_web" {
  instance_id = aws_instance.prod_web.0.id
  allocation_id = aws_eip.prod_web.id
}

resource "aws_eip" "prod_web" {
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_elb" "prod_web" {
  name = "prod-web"
  instances = aws_instance.prod_web.*.id
  subnets = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  security_groups = [aws_security_group.prod_web.id]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_launch_template" "prod_web" {
  name_prefix = "prod-web"
  image_id = "ami-019c091d13a1fa156"
  instance_type = 
}

resource "aws_autoscaling_group" "bar" {
  availability_zones = ["us-east-1a']
  desired_capacity = 1
  max_size = 1
  min_size = 1

  launch_template {
    id = 
    version = 
  }
}
