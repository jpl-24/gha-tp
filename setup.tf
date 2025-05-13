provider "aws" {
  region = "us-east-1"
}

#Crear vpc con rango ip 10.0.0.1
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "tp2-vpc"
  }
}

#Crear ipgateway
resource "aws_internet_gateway" "ipgw" {
  vpc_id = aws_vpc.vpc.id
}

#Tabla de rutero
data "aws_route_table" "tabla_ruteo" {
  filter {
    name   = "association.main"
    values = ["true"]
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }
}

#Crear tabla de ruteo
resource "aws_default_route_table" "internet_route" {
  default_route_table_id = data.aws_route_table.tabla_ruteo.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ipgw.id
  }
  tags = {
    Name = "Tp2-tabla-ruteo"
  }
}

#Habilitar zonas
data "aws_availability_zones" "azs_vpc" {
  state = "available"
}

#Crear subred
resource "aws_subnet" "subred" {
  availability_zone = element(data.aws_availability_zones.azs_vpc.names, 0)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
}

#Crear grupo de seguridad permitir TCP puertos 80 y 22
resource "aws_security_group" "gru-seg" {
  name        = "gru-seg"
  description = "Permitir TCP 80 y 22"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Permitir trafico SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Permitir trafico TCP/80"
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
}

output "Ip-publica-server-web" {
  value = aws_instance.apache_server.public_ip
}