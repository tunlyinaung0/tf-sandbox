resource "aws_instance" "bastion" {
  ami                         = local.ami-id
  instance_type               = "t2.small"
  availability_zone           = local.azs[1]
  subnet_id                   = module.vpc.public_subnets[1]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  key_name                    = local.key

  tags = {
    Name = "${local.prefix}-bastion"
  }


}

resource "aws_instance" "private-instance" {
  ami                         = local.ami-id
  instance_type               = "t2.small"
  availability_zone           = local.azs[0]
  subnet_id                   = module.vpc.private_subnets[0]
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.private-instance-sg.id]
  key_name                    = local.key

  tags = {
    Name = "${local.prefix}-private-instance"
  }
}

