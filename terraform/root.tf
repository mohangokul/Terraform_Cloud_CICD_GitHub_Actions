provider "aws" {
  region = "eu-west-1"
}


terraform {
  backend "s3" {
    bucket         = "neeha-s3bucket-date"
    key            = "globalstate/s3/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "neeha-date-dblocks"
    encrypt        = true
  }
} 

module "ec2-instance" {
  source = "./modules/ec2-instance"
  security_group_ids = module.vpc.security_group_ids
  subnet_id = module.vpc.subnet_id
}

module "vpc" {
  source = "./modules/network"
  
}