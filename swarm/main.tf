

#vpc
resource "aws_vpc" "swarm-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "swarm-vpc"
    ProjectName = "Swarm-Example"
    Created_With = "CloudSkiff"
  }
}

resource "aws_vpc_endpoint" "vpc_endpoints" {
  for_each = toset(var.interface_service_endpoints)
  
  vpc_id     = aws_vpc.swarm-vpc.id
  service_name = each.key
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.swarm-security-group.id
  ]
}

resource "aws_vpc_endpoint" "gateay_vpc_endpoints" {
  vpc_id     = aws_vpc.swarm-vpc.id
  service_name = "com.amazonaws.eu-west-2.s3"
  vpc_endpoint_type = "Gateway"
}

#subnet
resource "aws_subnet" "swarm-subnet" {
  vpc_id     = aws_vpc.swarm-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "swarm-subnet"
    ProjectName = "Swarm-Example"
    Created_With = "CloudSkiff"
  }
}

resource "aws_security_group" "swarm-security-group" {
  name        = "swarm_sg"
  description = "Allow docker swarm traffic"
  vpc_id      = aws_vpc.swarm-vpc.id


  ingress {
    description = "SSH from Matts home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["51.148.145.108/32"]
  }

  ingress {
    description = "SSL from Matts home"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["51.148.145.108/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_swarm_traffic"
    ProjectName = "Swarm-Example"
    Created_With = "CloudSkiff"
  }
}

resource "aws_internet_gateway" "swarm-gw" {
  vpc_id = aws_vpc.swarm-vpc.id

  tags = {
    Name = "swarm gateway"
    ProjectName = "Swarm-Example"
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
    ProjectName = "Swarm-Example"
    Created_With = "CloudSkiff"
  }
}

resource "aws_route_table_association" "route_table_assoc" {
  subnet_id      = aws_subnet.swarm-subnet.id
  route_table_id = aws_route_table.swarm-rt.id
}

# data "aws_ami" "amazon-ami" {
#   most_recent = true
#   owners = ["591542846629"] # AWS

#   filter {
#       name   = "name"
#       values = ["*amazon-ecs-optimized"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

resource "aws_instance" "web" {
  for_each = toset(var.instance_names)

  # ami           = data.aws_ami.amazon-ami.id
  ami           = "ami-032598fcc7e9d1c7a"
  instance_type = "t2.micro"

  key_name = "bytejunkie"
  subnet_id = aws_subnet.swarm-subnet.id
  iam_instance_profile = aws_iam_instance_profile.swarm_profile.name
  vpc_security_group_ids = [
    aws_security_group.swarm-security-group.id
    ]

  user_data = data.template_file.user_data.rendered
  
  tags = {
    Name  = format("%s-%s", each.key, "swarm-instance")
    ProjectName = "Swarm-Example"
    Created_With = "CloudSkiff"
  }
}



data "template_file" "user_data" {
  template = "${file("templates/user_data.tpl")}"
}

resource "aws_resourcegroups_group" "swarm-rg" {
  name = "swarm-example-rg"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance",
    "AWS::EC2::VPC",
    "AWS::EC2::Subnet",
    "AWS::EC2::InternetGateway",
    "AWS::EC2::RouteTable",
    "AWS::EC2::SecurityGroup"
  ],
  "TagFilters": [
    {
      "Key": "ProjectName",
      "Values": ["Swarm-Example"]
    }
  ]
}
JSON
  }
}

resource "aws_iam_instance_profile" "swarm_profile" {
  name = "swarm_profile"
  role = "AmazonSSMRoleForInstancesQuickSetup"
}