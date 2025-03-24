#DB subnet group
resource "aws_db_subnet_group" "twot-db-sg" {
  name       = "twot-db-sg"
  subnet_ids = [var.prisub_1, var.prisub_2]

  tags = {
    Name = "${var.twotproject}-db-sg"
  }
}

#MySQL RDS Database
resource "aws_db_instance" "twot_db" {
  allocated_storage      = 20
  db_name                = var.db_name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  storage_type           = var.storage_type
  identifier             = var.identifier
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = true
  availability_zone      = "us-east-1a"
  port                   = 3306
  db_subnet_group_name   = aws_db_subnet_group.twot-db-sg.id
  multi_az               = false
  vpc_security_group_ids = [var.db_sg]
}