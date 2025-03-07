resource "aws_vpc" "salesproject-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "salesproject-publicsubnet" {
  vpc_id                  = aws_vpc.salesproject-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "salesproject-privatesubnet-a" {
  vpc_id            = aws_vpc.salesproject-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "salesproject-privatesubnet-b" {
  vpc_id            = aws_vpc.salesproject-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-central-1b"
}

resource "aws_subnet" "salesproject-privatesubnet-c" {
  vpc_id            = aws_vpc.salesproject-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-central-1c"
}

resource "aws_internet_gateway" "salesproject-igw" {
  vpc_id = aws_vpc.salesproject-vpc.id
}

resource "aws_route_table" "salesproject-public-RT" {
  vpc_id = aws_vpc.salesproject-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.salesproject-igw.id
  }
}

resource "aws_route_table_association" "salesproject-public-RTA" {
  subnet_id      = aws_subnet.salesproject-publicsubnet.id
  route_table_id = aws_route_table.salesproject-public-RT.id
}

resource "aws_eip" "salesproject-nat-eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "salesproject-NAT" {
  allocation_id = aws_eip.salesproject-nat-eip.id
  subnet_id     = aws_subnet.salesproject-publicsubnet.id
}


resource "aws_route_table" "salesproject-private-RT" {
  vpc_id = aws_vpc.salesproject-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.salesproject-NAT.id
  }
}

# route table association for privatee subnet a
resource "aws_route_table_association" "salesproject-private-RTA-a" {
  subnet_id      = aws_subnet.salesproject-privatesubnet-a.id
  route_table_id = aws_route_table.salesproject-private-RT.id
}

resource "aws_route_table_association" "salesproject-private-RTA-b" {
  subnet_id      = aws_subnet.salesproject-privatesubnet-b.id
  route_table_id = aws_route_table.salesproject-private-RT.id
}

resource "aws_route_table_association" "salesproject-private-RTA-c" {
  subnet_id      = aws_subnet.salesproject-privatesubnet-c.id
  route_table_id = aws_route_table.salesproject-private-RT.id
}

resource "aws_redshift_subnet_group" "salesproject-redshift-subnet-group" {
  name = "redshift-subnet-group"
  subnet_ids = [
    aws_subnet.salesproject-privatesubnet-a.id,
    aws_subnet.salesproject-privatesubnet-b.id,
    aws_subnet.salesproject-privatesubnet-c.id
  ]
}

resource "aws_security_group" "salesproject-redshift-sg" {
  name        = "redshift-serverless-sg"
  description = "Security group for salesproject Redshift Serverless"
  vpc_id      = aws_vpc.salesproject-vpc.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
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