

#vpc
resource "aws_vpc" "swarm-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "dedicated"

  tags = {
    Name = "swarm-vpc"
  }
}

#subnet
resource "aws_subnet" "swarm-subnet" {
  vpc_id     = "${aws_vpc.swarm-vpc.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "swarm-subnet"
  }
}