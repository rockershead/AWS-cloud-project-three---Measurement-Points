terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.00"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
}


module "mpt" {

  source     = "./mpt"
  vpc_name   = var.vpc_name
  cidr_block = var.cidr_block

  private_subnet_cidrs        = var.private_subnet_cidrs
  azs                         = var.azs
  ingress_cidr                = var.ingress_cidr
  egress_cidr                 = var.egress_cidr
  record_lambda_function_name = var.record_lambda_function_name


  mpt_partition_key_name     = var.mpt_partition_key_name
  mpt_table_name             = var.mpt_table_name
  record_lambda_zip_filename = var.record_lambda_zip_filename

  mpt_sort_key_name        = var.mpt_sort_key_name
  get_lambda_function_name = var.get_lambda_function_name
  get_lambda_zip_filename  = var.get_lambda_zip_filename



}
