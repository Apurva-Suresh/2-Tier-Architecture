output "aws_db_subnet_group" {
  value = aws_db_subnet_group.twot-db-sg.id
}

output "aws_db_instance" {
  value = aws_db_instance.twot_db.id
}