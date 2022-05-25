resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = {
    Name = "main"
  }
}

resource "aws_subnet" "public-1a" {
  cidr_block        = "10.0.0.0/24"
  vpc_id            = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone = "eu-central-1a"
  tags              = {
    Name = "public-eu-central-1"
  }
}

resource "aws_subnet" "private-1a" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-central-1a"
  tags              = {
    Name = "private-eu-central-1"
  }
}

resource "aws_subnet" "public-2b" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-central-1b"
  tags              = {
    Name = "public-eu-central-2b"
  }
}

resource "aws_subnet" "private-2b" {
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-central-1b"
  tags              = {
    Name = "private-eu-central-2b"
  }
}