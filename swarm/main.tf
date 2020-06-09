

#vpc
resource "aws_vpc" "swarm-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "dedicated"

  tags = {
    Name = "swarm-vpc"
  }
}