terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#VPC
module "vpc" {
  source = "./modules/vpc"
  twotproject  = var.twotproject
  vpc_cidr     = var.vpc_cidr
  pubsub1_cidr = var.pubsub1_cidr
  pubsub2_cidr = var.pubsub2_cidr
  prisub1_cidr = var.prisub1_cidr
  prisub2_cidr = var.prisub2_cidr
}

#Security
module "security_group" {
  source = "./modules/security group"
  vpc_id = module.vpc.vpc_id
}

#ALB
module "alb" {
  source = "./modules/alb"
  twotproject  = var.twotproject
  vpc_id = module.vpc.vpc_id
  pubsub_1 = module.vpc.pubsub_1
  pubsub_2 = module.vpc.pubsub_2
  webserver1 = module.ec2.webserver1
  webserver2 = module.ec2.webserver2
  alb_sg = module.security_group.alb_sg
}

#EC2
module "ec2" {
  source = "./modules/ec2"
  ami_id = var.ami_id
  instance_type = var.instance_type
  pubsub_1 = module.vpc.pubsub_1
  pubsub_2 = module.vpc.pubsub_2
  public_sg = module.security_group.public_sg
}

#Database
module "database" {
  source = "./modules/database"
  twotproject  = var.twotproject
  db_name                = var.db_name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  storage_type           = var.storage_type
  identifier             = var.identifier
  db_username            = var.db_username
  db_password            = var.db_password
  parameter_group_name   = var.parameter_group_name
  db_sg                  = module.security_group.db_sg
  prisub_1               = module.vpc.prisub_1
  prisub_2               = module.vpc.prisub_2
}
