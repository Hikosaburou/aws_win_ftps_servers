resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.pj-prefix}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.pj-prefix}-public-a"
  }
}

resource "aws_subnet" "public-c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.pj-prefix}-public-c"
  }
}

resource "aws_subnet" "private-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.pj-prefix}-private-a"
  }
}

resource "aws_subnet" "private-c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.5.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.pj-prefix}-private-c"
  }
}

resource "aws_route_table" "public-a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.pj-prefix}-public-a"
  }
}

resource "aws_route_table" "public-c" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.pj-prefix}-public-c"
  }
}

resource "aws_route_table" "private-a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.pj-prefix}-private-a"
  }
}

resource "aws_route_table" "private-c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.pj-prefix}-private-c"
  }
}

resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public-a.id
}

resource "aws_route_table_association" "public-c" {
  subnet_id      = aws_subnet.public-c.id
  route_table_id = aws_route_table.public-c.id
}

/*
resource "aws_vpc_dhcp_options" "ad_optionset" {
  domain_name         = aws_directory_service_directory.test.name
  domain_name_servers = aws_directory_service_directory.test.dns_ip_addresses

  tags = {
    Name = "${var.pj-prefix}-dhcp-option-set"
  }
}

resource "aws_vpc_dhcp_options_association" "ad_optionset" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.ad_optionset.id
}
}
*/