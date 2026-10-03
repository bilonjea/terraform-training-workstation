resource "aws_vpc" "training" {
  cidr_block = "10.20.0.0/16"

  tags = {
    Name = "terraform-training-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.training.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = data.aws_ec2_instance_type_offerings.workstation.locations[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-training-public"
  }
}

resource "aws_internet_gateway" "training" {
  vpc_id = aws_vpc.training.id

  tags = {
    Name = "terraform-training-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.training.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.training.id
  }

  tags = {
    Name = "terraform-training-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}