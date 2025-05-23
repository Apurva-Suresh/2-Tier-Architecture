#VPCSG
resource "aws_security_group" "vpcsg" {
  name        = "vpcsg"
  description = "Allow all inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

##########################################################
# For ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow https,http inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

#http
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
#https
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# For Webservers
resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Allow ssh, http inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

#http
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.alb_sg.id] #allow inbound from ALB

  }
#ssh
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# For DB
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow MySQL inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

#MySQL
  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups = [aws_security_group.public_sg.id] #allow inbound from Webservers

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
