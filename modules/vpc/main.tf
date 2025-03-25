resource "aws_vpc" "twot_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.twotproject}-vpc"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "twot_igw" {
  vpc_id = aws_vpc.twot_vpc.id

  tags = {
    Name = "${var.twotproject}-igw"
  }
}

#Public-Subnet-1
resource "aws_subnet" "pubsub_1" {
  vpc_id     = aws_vpc.twot_vpc.id
  cidr_block = var.pubsub1_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.twotproject}-PubSub-1"
  }
}

#Public-Subnet-2
resource "aws_subnet" "pubsub_2" {
  vpc_id     = aws_vpc.twot_vpc.id
  cidr_block = var.pubsub2_cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.twotproject}-PubSub-2"
  }
}

#Private-Subnet-1
resource "aws_subnet" "prisub_1" {
  vpc_id     = aws_vpc.twot_vpc.id
  cidr_block = var.prisub1_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.twotproject}-PriSub-1"
  }
}

#Private-Subnet-2
resource "aws_subnet" "prisub_2" {
  vpc_id     = aws_vpc.twot_vpc.id
  cidr_block = var.prisub2_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.twotproject}-PriSubnet-2"
  }
}

#Public Route Table
resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.twot_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.twot_igw.id
  }

  tags = {
    Name = "${var.twotproject}-Public-RT"
  }
}

#Route Table Association to both Pub-Sub-1 and Pub-Sub-2
resource "aws_route_table_association" "rt_pubsub_1" {
  subnet_id      = aws_subnet.pubsub_1.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_route_table_association" "rt_pubsub_2" {
  subnet_id      = aws_subnet.pubsub_2.id
  route_table_id = aws_route_table.pubrt.id
}
