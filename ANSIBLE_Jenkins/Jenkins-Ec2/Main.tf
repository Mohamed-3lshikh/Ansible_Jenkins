


resource "aws_security_group" "Jenkins-SG" {
  name        = "Jenkins-Security Group"
  description = "Open 22,443,80,8080"

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443, 8080] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-SG"
  }
}


resource "aws_instance" "web" {
  ami                    = "ami-081983be3066fc481"
  instance_type          = "t2.micro"
  key_name               = "AWS-Key"
  vpc_security_group_ids = [aws_security_group.Jenkins-SC.id]
  user_data              = templatefile("./install_jenkins.sh", {})

  tags = {
    Name = "Jenkins-SG"
  }
  root_block_device {
    volume_size = 8
  }
}
