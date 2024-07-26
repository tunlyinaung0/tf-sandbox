module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.prefix}-vpc"
  cidr = local.vpc-cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  
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

  igw_tags = {
    Name = "${local.prefix}-igw"
  }

  tags = {
    Name = "${local.prefix}-vpc"
  }
}

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

