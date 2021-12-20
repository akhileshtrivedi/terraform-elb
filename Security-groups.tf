resource "aws_security_group" "webservers" {
  name        = "allow_http"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id


  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "My_security_group"
  }
}
