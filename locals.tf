locals {
  region          = "us-east-1"
  prefix          = "sandbox"
  vpc-cidr        = "10.1.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.1.0.0/24", "10.1.1.0/24"]
  private_subnets = ["10.1.2.0/24", "10.1.3.0/24"]
  ami-id          = "ami-04a81a99f5ec58529"
  key             = "ec2"
}