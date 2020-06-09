

#vpc
resource "aws_vpc" "swarm-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "dedicated"

  tags = {
    Name = "swarm-vpc"
    Created_With = "CloudSkiff"
  }
}

#subnet
resource "aws_subnet" "swarm-subnet" {
  vpc_id     = aws_vpc.swarm-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "swarm-subnet"
    Created_With = "CloudSkiff"
  }
}

resource "aws_security_group" "swarm-security-group" {
  name        = "swarm_sg"
  description = "Allow docker swarm traffic"
  vpc_id      = aws_vpc.swarm-vpc.id


  tags = {
    Name = "allow_swarm_traffic"
    Created_With = "CloudSkiff"
  }
}

resource "aws_internet_gateway" "swarm-gw" {
  vpc_id = aws_vpc.swarm-vpc.id

  tags = {
    Name = "swarm gateway"
    Created_With = "CloudSkiff"
  }
}

resource "aws_route_table" "swarm-rt" {
  vpc_id = aws_vpc.swarm-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.swarm-gw.id
  }

  tags = {
    Name = "swarm-route-table"
    Created_With = "CloudSkiff"
  }
}

resource "aws_route_table_association" "route_table_assoc" {
  subnet_id      = aws_subnet.swarm-subnet.id
  route_table_id = aws_route_table.swarm-rt.id
}

data "aws_ami" "amazon-ami" {
  most_recent = true
  owners = ["591542846629"] # AWS

  filter {
      name   = "name"
      values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon-ami.id
  instance_type = "t2.micro"

  tags = {
    Name = "swarm-instance"
    Created_With = "CloudSkiff"
  }
}