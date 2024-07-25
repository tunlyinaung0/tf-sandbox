output "bastion-public-ip" {
  value = aws_instance.bastion.public_ip
}

output "private-instance-private-ip" {
  value = aws_instance.private-instance.private_ip
}