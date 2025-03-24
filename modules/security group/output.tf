output "vpcsg" {
  value = aws_security_group.vpcsg.id
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "public_sg" {
  value = aws_security_group.public_sg.id
}

output "db_sg" {
  value = aws_security_group.db_sg.id
}