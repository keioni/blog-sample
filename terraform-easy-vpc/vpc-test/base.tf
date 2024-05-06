terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = local.aws_region

  default_tags {
    tags = {
      Env = local.env
      App = local.app
    }
  }
}

module "vpc-sample" {
  source = "../"

  env                = local.env
  app                = local.app
  aws_region         = local.aws_region
  vpc_cidr_block     = local.vpc_cidr_block
  subnet_mask_length = local.subnet_mask_length
}
