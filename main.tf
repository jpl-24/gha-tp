#servidor web apache en ubuntu
resource "aws_instance" "apache_server" {
  ami                         = "ami-084568db4383264d4"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.gru-seg.id]
  subnet_id                   = aws_subnet.subred.id
  user_data                   = "${file("crear_apache_server.sh")}"
tags = {
    Name = "apache_server"
  }
}