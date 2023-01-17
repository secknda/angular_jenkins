provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "my_security_group" {
  name = "my_security_group"
  vpc_id = vpc-08eb065c91b62c95b

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "my_launch_config" {
  image_id = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.my_security_group.name]
  user_data = <<EOF
    #!/bin/bash
    echo "docker swarm join --token $SWARM_TOKEN $SWARM_MANAGER"
  EOF
}

resource "aws_autoscaling_group" "my_asg" {
  launch_configuration = aws_launch_configuration.my_launch_config.name
  min_size = 1
  max_size = 5
  desired_capacity = 2
  vpc_zone_identifier = [aws_subnet.my_subnet.id]
  availability_zones = ["us-west-2a","us-west-2b","us-west-2c"]
}

resource "aws_elb" "my_elb" {
  name = "my-elb"
  availability_zones = ["us-west-2a","us-west-2b","us-west-2c"]
  security_groups = [aws_security_group.my_security_group.id]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  elb = aws_elb.my_elb.name
}
