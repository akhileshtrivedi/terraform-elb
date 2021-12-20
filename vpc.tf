# Create VPC for our application
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "MyVPC"
  }
}
# Create internet gateway and attach it to VPC
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "main"
  }
}
#Build subnets for our VPCs

resource "aws_subnet" "public_subnets" {
  count                   = length(var.subnets_cidr)
  vpc_id                  = aws_vpc.my_vpc.id
  availability_zone       = element(var.azs, count.index)
  cidr_block              = element(var.subnets_cidr, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet-${count.index + 1}"
  }
}
#Create Route table, attach Internet gateway and associate with public subnets

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "publicRT"
  }
}
resource "aws_route_table_association" "a" {
  count          = length(var.subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}
