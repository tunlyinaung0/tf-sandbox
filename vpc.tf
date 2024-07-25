module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.prefix}-vpc"
  cidr = local.vpc-cidr

  azs             = local.azs
  private_subnets = local.public_subnets
  public_subnets  = local.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  create_igw         = true

  public_subnet_tags = {
    Name = "${local.prefix}-public"
  }

  private_subnet_tags = {
    Name = "${local.prefix}-private"
  }

  nat_gateway_tags = {
    Name = "${local.prefix}-nat-gw"
  }

  tags = {
    Name = "${local.prefix}-vpc"
  }
}

# resource "aws_eip" "for-nat" {
#     domain = "vpc"
# }

# resource "aws_nat_gateway" "nat" {
#     allocation_id = aws_eip.for-nat.id
#     subnet_id = module.vpc.public_subnets[0]

#     tags = {
#         Name = "${local.prefix}-nat"
#     }
# }

# resource "aws_route_table" "public_rtb" {
#     vpc_id = module.vpc.vpc_id 

#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = module.vpc.igw_id
#     }

#     tags = {
#       Name = "${local.prefix}-public-rtb"
#     }
# }

# resource "aws_route_table" "private_rtb" {
#     vpc_id = module.vpc.vpc_id

#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_nat_gateway.nat.id
#     }

#     tags = {
#         Name = "${local.prefix}-private-rtb"
#     }
# }

# resource "aws_route_table_association" "public_rtb_association" {
#     count = length(local.public_subnets)
#     subnet_id = module.vpc.public_subnets[count.index]
#     route_table_id = aws_route_table.public_rtb.id
# }

# resource "aws_route_table_association" "private_rtb_association" {
#     count = length(local.private_subnets)
#     subnet_id = module.vpc.private_subnets[count.index]
#     route_table_id = aws_route_table.private_rtb.id
# }


resource "aws_security_group" "bastion-sg" {
  name   = "bastion-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.prefix}-bastion-sg"
  }
}

resource "aws_security_group" "private-instance-sg" {
  name   = "private-instance-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.prefix}-private-instance-sg"
  }
}

